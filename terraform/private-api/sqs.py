import boto3 
import json 
import logging 


logger = logging.getLogger()
logger.setLevel("INFO")

sqs_client = boto3.client("sqs", region_name="us-east-2")

def lambda_handler(event, context):
    logger.info(f"Lambda Event {event}")
    
    body = event["body"]
    
    auth = False 
    if event["orgId"] == "d-abc123":
        auth = True 
    else: 
        auth = False 
        
    if not auth:
        return json.dumps({
            "statusCode": 403,
            "message" : "Ypu are unauthorized to invoke this lambda"
        })
    else:
        send_message()
        return json.dumps({
            "statusCode" : 200,
            "message" : "Message sent to SQS successfully"
        })
           

def send_message():
    message = {"key": "message value"}
    response = sqs_client.send_message(
        QueueUrl="your-queue-url",
        MessageBody=json.dumps(message)
    )
    
    print(response)
 