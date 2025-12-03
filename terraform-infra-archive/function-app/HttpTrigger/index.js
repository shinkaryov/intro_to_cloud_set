module.exports = async function (context, req) {
    context.log('HTTP trigger function processed a request.');

    const name = (req.query.name || (req.body && req.body.name));
    const responseMessage = name
        ? `Hello from Azure Functions, ${name}!`
        : "Hello from Azure Functions!";

    context.res = {
        status: 200,
        body: responseMessage
    };
}