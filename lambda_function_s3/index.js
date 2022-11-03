const aws = require("aws-sdk");
var lambda = new aws.Lambda({
    region: 'us-east-1'
});

console.log('loading...');

const s3 = new aws.S3({apiVersion: '2006-03-01'});

function callLambda(event) {
    return new Promise(async (resolve, reject) => { 
        lambda.invoke({
            FunctionName: 'GetDynamoDBItem',
            Payload: JSON.stringify(event)
        },  function (error, data) {
            if (error)
                reject(error);
            var res = JSON.parse(data.Payload)
            resolve(res);
        })
    });
};

exports.handler = async (event, context) => {
    const params = {
        Bucket: "test-poc-jsons",
        Key: `compound-${event.key}.json`,
    };
    const headers = {
        'Access-Control-Allow-Credentials': true,
        'Access-Control-Allow-Headers': 'Authorization,Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS,POST',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
    }
    
    try {
        const data = await s3.getObject(params).promise();
        const res = JSON.parse(data.Body);
        return res;
    } catch (e) {
        const data = await callLambda(event);
        return data;
    }
}