import boto3
import json 

sf = boto3.client("stepfunction")

with open("event.json", "r") as file:
    event = json.load(file)

response = sf.start_execution(
    stateMachineArn = "arn-of-step-function-machine",
    input = json.dumps(event)
)
