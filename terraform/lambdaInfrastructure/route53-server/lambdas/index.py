import os
import time 
import boto3
import csv
import logging
from pprint import pprint

ec2 = boto3.resource('ec2')
ec2_client = boto3.client('ec2')
autoscaling_client = boto3.client("autoscaling")
s3 = boto3.resource('s3')
logs = boto3.client("logs")
alb_client = boto3.client("elb")
dynamodb = boto3.resource("dynamodb")

logger = logging.getLogger()
logger.setLevel("INFO")

ENVIRONMENT = os.environ.get("ENVIRONMENT")
REGION="us-east-1"
LOG_GROUP=f"/aws/lambda/inventory-lambda-dev-{REGION}"
LOG_STREAM="stream1"

def get_timestamp():
    return int(round(time.time() * 1000))
    

def upload_to_dynamodb(resources, details, resource_type):
    logger.info(f"Uploading {len(resources)} {resource_type} resources to db {details}")
    pprint(details)
    table = dynamodb.Table("inventoryTable")
    timestamp = get_timestamp()
   
    try:
        response = None
        # with table.batch_writer() as batch
        for i in resources:
            print(f"resources {i['name']}")
            response = table.put_item(
                Item={
                    "resourceName" : i["name"],
                    "resourceType" : resource_type,
                    "details": details,
                }
            )
            
        pprint(response)
        
        if response == None:
            pprint(f"No Response was returned")
            logger.warning(f"Dynamo DB returned no response. {timestamp}")
            return 
        if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
            print("Item added successfully")
            log_details = f"{resources} {details} {resource_type}"
            print(log_details)
            logger.log(f"{log_details} are saved in the database. {timestamp}")
            # write_to_cloudwatch(log_details)
    except Exception as e:
        print(f"An Error Occured  {e}")
        logger.error(f"An error occurred when writing to the DB {e}")
        # write_to_cloudwatch(f"An Error Occured {response}")
 

def lambda_handler(event, context):
    logger.info(f"Incoming event {event}")
    #Filter instances based on instance type
    ec2_inventory()
    s3_name_inventory()
    alb_inventory()
    # TODO: Call all inventory functions
   
  
def ec2_inventory():
    instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['stopped','running','pending','stopping','shutting-down']}])
    types = ['t3','c4','m3']
    current_instances = []
    pprint(instances)
    for instance in instances:
        instance_type = instance.instance_type
        if any(x in instance_type for x in types):
            current_instances.append([instance.id,instance.instance_type, REGION])
    pprint(current_instances)
    upload_to_dynamodb(current_instances, instances, "EC2")
        
def s3_name_inventory():
    buckets = [bucket.name for bucket in s3.buckets.all()]
    s3_client = boto3.client("s3")
    
    details = s3_client.list_buckets()
   
    bucket_list = []
    for bucket in buckets:
        bucket_list.append({"name": bucket})
    upload_to_dynamodb(bucket_list, details, "S3")
    
    
def vpc_endpoints_inventory():
    endpoints_details = ec2_client.describe_vpc_endpoints()
    pprint(endpoints_details["VpcEndpoints"])
    vpc_endpoints = endpoints_details["VpcEndpoints"]
    if vpc_endpoints == []:
        pprint("There are no VPC Endpoints found.")
        return
    upload_to_dynamodb(vpc_endpoints, endpoints_details, "VPC Endpoints")
    
def security_group_inventory():
    sg_details = ec2_client.describe_security_groups()
    groups = [{"name": group['GroupName']}
           for group in sg_details['SecurityGroups']]
    
    pprint(f"Security Groups {groups}")
    upload_to_dynamodb(groups,sg_details, "Security Groups")
   
    
def autoscaling_inventory():
    response = autoscaling_client.describe_auto_scaling_groups()
    pprint(response)
    upload_to_dynamodb(response, "ASG")
    
def alb_inventory():
    response = alb_client.describe_load_balancers()
    pprint(response)
    albs = response["LoadBalancerDescriptions"]
    upload_to_dynamodb(albs, response, "ALB")

lambda_handler(1,1)