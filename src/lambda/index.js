const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

const TABLE_NAME = process.env.TABLE_NAME || 'crud';

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));
  const { httpMethod, body, pathParameters } = event;

  try {
    let response;
    const id = pathParameters?.id;

    switch (httpMethod) {
      case 'POST':
        response = await handleRequest(createItem, JSON.parse(body));
        break;
      case 'GET':
        response = id ? await handleRequest(getItem, { id }) : await handleRequest(scanTable);
        break;
      case 'PUT':
        response = id ? await handleRequest(updateItem, { id, ...JSON.parse(body) }) : buildResponse(400, 'Missing ID in path parameters');
        break;
      case 'DELETE':
        response = id ? await handleRequest(deleteItem, { id }) : buildResponse(400, 'Missing ID in path parameters');
        break;
      default:
        response = buildResponse(405, 'Method Not Allowed');
    }

    return response;
  } catch (error) {
    console.error("Error processing request:", error);
    return buildResponse(500, 'Internal Server Error');
  }
};

const handleRequest = async (operation, params) => {
  try {
    const result = await operation(params);
    return buildResponse(result.statusCode, result.body);
  } catch (error) {
    console.error(`Error executing ${operation.name}:`, error);
    return buildResponse(500, error.message);
  }
};

const createItem = async ({ id, ...item }) => {
  const params = { TableName: TABLE_NAME, Item: { id, ...item } };
  await dynamodb.put(params).promise();
  return { statusCode: 201, body: params.Item };
};

const getItem = async ({ id }) => {
  const params = { TableName: TABLE_NAME, Key: { id } };
  const result = await dynamodb.get(params).promise();
  return result.Item ? { statusCode: 200, body: result.Item } : { statusCode: 404, body: 'Item not found' };
};

const scanTable = async () => {
  const params = { TableName: TABLE_NAME };
  const result = await dynamodb.scan(params).promise();
  return { statusCode: 200, body: result.Items };
};

const updateItem = async ({ id, ...updateData }) => {
  const params = {
    TableName: TABLE_NAME,
    Key: { id },
    UpdateExpression: `set ${Object.keys(updateData).map((key, i) => `#${key} = :value${i}`).join(', ')}`,
    ExpressionAttributeNames: Object.keys(updateData).reduce((acc, key) => ({ ...acc, [`#${key}`]: key }), {}),
    ExpressionAttributeValues: Object.keys(updateData).reduce((acc, key, i) => ({ ...acc, [`:value${i}`]: updateData[key] }), {}),
    ReturnValues: 'ALL_NEW'
  };
  const result = await dynamodb.update(params).promise();
  return { statusCode: 200, body: result.Attributes };
};

const deleteItem = async ({ id }) => {
  const params = { TableName: TABLE_NAME, Key: { id } };
  await dynamodb.delete(params).promise();
  return { statusCode: 204, body: null };
};

const buildResponse = (statusCode, body) => ({
  statusCode,
  body: JSON.stringify(body),
});
