import os 
import aws_cdk 
from aws_cdk import Stack, Duration
from aws_cdk import(
    aws_lambda as dj_lambda,
    aws_apigateway as apigateway,
    aws_s3 as s3,
    aws_s3_deployment as s3_deploymwent,
)
from dotenv import load_dotenv
from constructs import Construct

load_dotenv()

class CdkLambdaStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
         # Create an S3 Bucket for Django Static Files
        static_bucket = s3.Bucket(
            self,
            id="scim-api-admin-static-files",
            bucket_name="scim-api-bucket-useast1",
            encryption=s3.BucketEncryption.S3_MANAGED,   
        )
        
        # Lambda Function for the Django Scim App
        django_lambda = dj_lambda.Function(
            self, 
            id="scim-api-lambda",
            function_name=f"scim-api-lambda",
            runtime=dj_lambda.Runtime.PYTHON_3_12,
            code=dj_lambda.Code.from_asset("../django-scim"),
            environment={
                "DJANGO_SETTINGS_MODULE" : "usermanagement.settings",
                "AWS_STORAGE_BUCKET_NAME" : static_bucket.bucket_name,
                "DJANGO_SUPERUSER_PASSWORD": os.environ.get(
                    "DJANGO_SUPERUSER_PASSWORD", "Mypassword1!"
                ),
                "DJANGO_SUPERUSER_USERNAME": os.environ.get(
                    "DJANGO_SUPERUSER_USERNAME", "admin"
                ),
                "SECRET_KEY" : os.environ.get("SECRET_KEY"),
                "DJANGO_ADMIN_URL" : os.environ.get("DJANGO_ADMIN_URL"),
            },
            timeout=Duration.minutes(5),
            memory_size=512,
            handler="scimapi.wsgi.handler",
        )
        
        # Grants the Lambda Permissions to access S3
        static_bucket.grant_read_write(django_lambda)
        
        #API Gateway creates a REST API for the Lambda
        api = apigateway.LambdaRestApi(
            self,
            id="scim-api-gateway",
            handler=django_lambda,
            proxy=True,
        )
        
        # Deploy Django static files to S3
        s3_deploymwent.BucketDeployment(
            self,
            id="deploy-static-files",
            destination_bucket=static_bucket,
            sources=[s3_deploymwent.Source.asset("../django-scim/staticfiles/")],
        )
        
        aws_cdk.CfnOutput(self, "Apiurl", value=api.url)
        
