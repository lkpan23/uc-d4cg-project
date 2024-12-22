import logging
import json

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Entry point for the AWS Lambda function.
    Logs a message when triggered and processes the event.
    """
    try:
        # Log the received event
        logger.info("Lambda function triggered by CloudWatch Event.")
        logger.info(f"Received event: {json.dumps(event)}")

        # Perform any task here (if needed)
        # Example: print a message
        logger.info("Cron job executed successfully.")

        # Return a success response
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Lambda executed successfully!"})
        }
    except Exception as e:
        # Log and return error response
        logger.error(f"Error occurred: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
