const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

const TABLE_NAME = process.env.TABLE_NAME || '';

exports.handler = async (event) => {
  const { httpMethod, body, pathParameters } = event;
  let response;

  switch (httpMethod) {
    case 'POST':
      response = await createItem(JSON.parse(body));
      break;
    case 'GET':
      if (pathParameters && pathParameters.id) {
        response = await getItem(pathParameters.id);
      } else {
        response = await scanTable();
      }
      break;
    case 'PUT':
      response = await updateItem(pathParameters.id, JSON.parse(body));
      break;
    case 'DELETE':
      response = await deleteItem(pathParameters.id);
      break;
    default:
      response = buildResponse(405, 'Method Not Allowed');
  }

  return response;
};

const createItem = async (item) => {
  const params = {
    TableName: TABLE_NAME,
    Item: item,
  };

  try {
    await dynamodb.put(params).promise();
    return buildResponse(201, item);
  } catch (error) {
    return buildResponse(500, error.message);
  }
};

const getItem = async (id) => {
  const params = {
    TableName: TABLE_NAME,
    Key: { id },
  };

  try {
    const result = await dynamodb.get(params).promise();
    if (result.Item) {
      return buildResponse(200, result.Item);
    } else {
      return buildResponse(404, 'Item not found');
    }
  } catch (error) {
    return buildResponse(500, error.message);
  }
};

const scanTable = async () => {
  const params = {
    TableName: TABLE_NAME,
  };

  try {
    const result = await dynamodb.scan(params).promise();
    return buildResponse(200, result.Items);
  } catch (error) {
    return buildResponse(500, error.message);
  }
};

const updateItem = async (id, updateData) => {
  const params = {
    TableName: TABLE_NAME,
    Key: { id },
    UpdateExpression: 'set #attrName = :attrValue',
    ExpressionAttributeNames: { '#attrName': Object.keys(updateData)[0] },
    ExpressionAttributeValues: { ':attrValue': Object.values(updateData)[0] },
    ReturnValues: 'ALL_NEW',
  };

  try {
    const result = await dynamodb.update(params).promise();
    return buildResponse(200, result.Attributes);
  } catch (error) {
    return buildResponse(500, error.message);
  }
};

const deleteItem = async (id) => {
  const params = {
    TableName: TABLE_NAME,
    Key: { id },
  };

  try {
    await dynamodb.delete(params).promise();
    return buildResponse(204, null);
  } catch (error) {
    return buildResponse(500, error.message);
  }
};

const buildResponse = (statusCode, body) => {
  return {
    statusCode,
    body: JSON.stringify(body),
  };
};
