import logging 

logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    # Log event
    logger.info(f"Auth Event {event}")
    
    # check token validity
    if event["authToken"] == "abc123":
        auth = "Allow"
    else: 
        auth = "Deny"
        
    # return a response
    auth_response = {}
    auth_response["PrincipalId"] = "abc123"  #authorizor should have the same Token Source set in the AWS UI
    auth_response["policyDocument"] = {
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Action": "execute-api:Invoke",
                "Resource" : ["arn:aws:execute-api:us-east-1:your-account-id:your-api-identifier/*/*"], # gives permission to call all api endpoints
                "Effect" : auth 
            }
        ]
    }
    
    return auth_response