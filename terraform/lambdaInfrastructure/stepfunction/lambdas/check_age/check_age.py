import json
import logging 

logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    logger.info(f"Incoming event {event}")
    user_info = json.loads(event["body"])
    
    age = user_info["age"] 
    
    if age < 18:
        logger.error("User is too young to create an account.")
        return {
            "statusCode" : 403,
            "body" : "You must be at least 18 years old to create an AWS Account",
            "success" : False
        }
    
    logger.info("User can create an account.")
    return {
        "statusCode" : 200,
        "body" : "You are old enough to create an AWS account",
        "success" : True
    }