import { APIGatewayProxyEvent, APIGatewayProxyResult, Context } from 'aws-lambda';
import { Metrics, MetricUnits } from '@aws-lambda-powertools/metrics';
import { Logger } from '@aws-lambda-powertools/logger';
const metrics = new Metrics();
const logger = new Logger();

/**
 *
 * Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
 * @param {APIGatewayProxyEvent} event - API Gateway Lambda Proxy Input Format
 * @param {Context} object - API Gateway Lambda $context variable
 *
 * Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
 * @returns {APIGatewayProxyResult} object - API Gateway Lambda Proxy Output Format
 *
 */

export const lambdaHandler = async (event: APIGatewayProxyEvent, context: Context): Promise<APIGatewayProxyResult> => {
    let response: APIGatewayProxyResult;

    // Capture cold start metrics
    metrics.captureColdStartMetric();

    try {
        // hello world code
        response = {
            statusCode: 200,
            body: JSON.stringify({
                message: 'hello world',
            }),
        };
        logger.info('This is an INFO log - sending HTTP 200 - hello world response');
    } catch (err) {
        // Error handling
        response = {
            statusCode: 500,
            body: JSON.stringify({
                message: 'some error happened',
            }),
        };
        logger.error('This is an ERROR log - sending HTTP 500 - some error happened response');
    } finally {
        // Publish all stored metrics
        metrics.publishStoredMetrics();
    }

    return response;
};
