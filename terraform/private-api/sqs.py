import boto3 
import json 


sqs_client = boto3.client("sqs", region_name="us-east-2")

def send_message():
    message = {"key": "message value"}
    response = sqs_client.send_message(
        QueueUrl="your-queue-url",
        MessageBody=json.dumps(message)
    )
    
    print(response)
 