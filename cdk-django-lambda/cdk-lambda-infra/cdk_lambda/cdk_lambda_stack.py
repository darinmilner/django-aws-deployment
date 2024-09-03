import os
import subprocess
import aws_cdk 
from aws_cdk import(
    aws_lambda as dj_lambda,
    aws_apigateway as apigateway,
    aws_s3 as s3,
    aws_s3_deployment as s3_deploymwent,
    Stack,
    Duration,
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
            id="django-hello-admin-static-files",
            bucket_name=f"{os.getenv('BUCKET_NAME')}-{os.getenv('SHORT_REGION')}",
            encryption=s3.BucketEncryption.S3_MANAGED,   
        )
        
        # Lambda Function for the Django Scim App
        django_lambda = dj_lambda.Function(
            self, 
            id="django-hello-lambda",
            function_name=f"django-hello-lambda-{os.getenv('SHORT_REGION')}",
            runtime=dj_lambda.Runtime.PYTHON_3_12,
            code=dj_lambda.Code.from_asset("../django-hello/app"),
            # TODO: Set environment variables
            environment={
                "DJANGO_SETTINGS_MODULE" : "app.settings",
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
            memory_size=1024,
            handler="lambda_function.lambda_handler",
            layers=[self.create_dependencies_layer(self.stack_name, "test_lambda")]
        )
           
       # Grants the Lambda Permissions to access S3
        static_bucket.grant_read_write(django_lambda)
        
        #API Gateway creates an Edge REST API for the Lambda
        api = apigateway.LambdaRestApi(
            self,
            id="django-hello-gateway",
            handler=django_lambda,
            proxy=True,
        )
        
        # hello_route = api.root.add_resource("hello")
        # hello_route.add_method("GET")
        
        # admin_route = api.root.add_resource(os.environ.get("DJANGO_ADMIN_URL"))
        # admin_route.add_method("GET")
        
        # Deploy Django static files to S3
        s3_deploymwent.BucketDeployment(
            self,
            id="deploy-static-files",
            destination_bucket=static_bucket,
            sources=[s3_deploymwent.Source.asset("../django-hello/django-app/staticfiles/")],
        )
        
        aws_cdk.CfnOutput(self, "Apiurl", value=api.url)
        
    def create_dependencies_layer(self, project_name, function_name: str) -> dj_lambda.LayerVersion:
        requirements_file = "../django-hello/django-app/requirements.txt"  # requirements.txt
        output_dir = "./build/app"  # temporary directory to store dependencies
        
        subprocess.check_call(f"pip install -r {requirements_file} -t {output_dir}/python".split())
        
        layer_id = f"{project_name}-{function_name}-dependencies"
        layer_code = dj_lambda.Code.from_asset(output_dir)
        
        layer = dj_lambda.LayerVersion(
                self,
                layer_id,
                code=layer_code,
        )
        
        return layer 
        
