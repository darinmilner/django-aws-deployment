import json
import logging 
import boto3

logger = logging.getLogger()
logger.setLevel("INFO")

# Create an S3 client
s3 = boto3.client("s3")

def lambda_handler(event, context):
    logger.info(f"Incoming event {event}")
    body = json.loads(event["body"])
    
    region = body["region"]
    bucket_name = body["bucketName"]
    
    try:
        response = s3.create_bucket(
            Bucket=bucket_name,
            CreateBucketConfiguration={
                "LocationConstraint" : region
            }
        )
        
        return {
            "statusCode" : 201,
            "message" : "Bucket successfully created.",
            "response" : response,
            "success" : True
        }
    except Exception as e:
        logger.error(f"Something went wrong {e}")
        return {
            "statusCode" : 500,
            "message" : "Something went wrong",
            "success" : False 
        }