#!/usr/bin/env python3
import aws_cdk as cdk
from aws.aws_stack import AwsStack

app = cdk.App()

AwsStack(
    app,  
    "django-scim", 
    "code-pipeline-aws-arn",  # TODO: create and add code pipeline arn
    stack_name="scim-api",
)

app.synth()
