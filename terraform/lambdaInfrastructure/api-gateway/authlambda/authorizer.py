import logging 
import os 

account_id = os.environ["AccountId"]
region = os.environ["Region"]
api_id = os.environ["ApiId"]

logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    # Log event
    logger.info(f"Auth Event {event}")
    
    # check token validity
    if event["authoriationToken"] == "d-abc123":
        auth = "Allow"
    else: 
        auth = "Deny"
        
    # return a response
    auth_response = {}
    auth_response["principalId"] = "d-abc123"  #authorizor should have the same Token Source set in the AWS UI
    auth_response["policyDocument"] = {
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Action": "execute-api:Invoke",
                "Resource" : [f"arn:aws:execute-api:{region}:{account_id}:{api_id}/*/*"], # gives permission to call all api endpoints
                "Effect" : auth 
            }
        ]
    }
    
    return auth_response
