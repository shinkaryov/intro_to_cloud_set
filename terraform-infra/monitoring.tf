resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-vm-monitoring"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# VM Insights (Azure Monitor Agent)
resource "azurerm_virtual_machine_extension" "monitor_agent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.21"
  auto_upgrade_minor_version = true

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Data Collection Rule for VM metrics
resource "azurerm_monitor_data_collection_rule" "vm_dcr" {
  name                = "dcr-vm-metrics"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "log-analytics-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["log-analytics-destination"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "Processor(*)\\% Processor Time",
        "Memory(*)\\Available MBytes",
        "LogicalDisk(*)\\% Free Space"
      ]
      name = "perfCounterDataSource"
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Associate VM with Data Collection Rule
resource "azurerm_monitor_data_collection_rule_association" "vm_dcr_assoc" {
  name                    = "dcra-vm-metrics"
  target_resource_id      = azurerm_linux_virtual_machine.vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vm_dcr.id
}

# Action Group for alert notifications
resource "azurerm_monitor_action_group" "cpu_alert_action" {
  name                = "ag-cpu-alert"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "cpualert"

  email_receiver {
    name          = "sendtoadmin"
    email_address = var.alert_email_address
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Metric Alert for CPU > 70%
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "alert-cpu-high"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  description         = "Alert when CPU usage exceeds 70%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id = azurerm_monitor_action_group.cpu_alert_action.id
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}