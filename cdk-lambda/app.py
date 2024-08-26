#!/usr/bin/env python3
import os

import aws_cdk as cdk

from cdk_lambda.cdk_lambda_stack import CdkLambdaStack


app = cdk.App()
CdkLambdaStack(app, "CdkLambdaStack", )

app.synth()
