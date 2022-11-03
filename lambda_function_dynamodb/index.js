const aws = require('aws-sdk');
const docClient = new aws.DynamoDB.DocumentClient();

const params = {
    TableName : 'Compound'
}

async function getItem(id){
    try {
        params['Key'] = { 'ChemSpiderId': id }
        const data = await docClient.get(params).promise();
        if (!data.Item)
            throw new Error(`Compound ${id} not found.`)
        return data;
    } 
    catch (err) {
        throw err;
    }
}

exports.handler = async (event, context) => {
    try {
        const data = await getItem(event.key);
        return data.Item;
    } 
    catch (err) {
        throw err;
    }
}
