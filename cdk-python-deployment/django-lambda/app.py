#!/usr/bin/env python3
import os
from aws_cdk import core

from django_lambda.django_lambda_stack import DjangoLambdaStack


app = core.App()
DjangoLambdaStack(app, "DjangoLambdaStack", )

app.synth()
