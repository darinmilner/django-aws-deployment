import os
import time 
import boto3
import csv
from pprint import pprint

ec2 = boto3.resource('ec2')
ec2_client = boto3.client('ec2')
autoscaling_client = boto3.client("autoscaling")
s3 = boto3.resource('s3')
logs = boto3.client("logs")
dynamodb = boto3.resource("dynamodb")

ENVIRONMENT = os.environ.get("ENVIRONMENT")
REGION="us-east-1"
LOG_GROUP=f"/aws/lambda/inventory-lambda-dev-{REGION}"
LOG_STREAM="stream1"


def write_to_cloudwatch(details):
    timestamp = int(round(time.time() * 1000))
    
    response = logs.put_log_events(
        logGroupName=LOG_GROUP,
        logStreamName=LOG_STREAM,
        logEvents=[
            {
                "timestamp": timestamp,
                "message" : f"New Inventory Details {details}"
            }
        ]
    )
    
    pprint(response)
    

def upload_to_dynamodb(details, resource_type):
    pprint(f"Uploading {len(details)} {resource_type} details to db {details}")
    table = dynamodb.Table("inventoryTable")
    try:
        response = None
        # with table.batch_writer() as batch:
        for i in details:
            print(f"details {i['name']}")
            response = table.put_item(
                Item={
                    "resourceName" : i["name"],
                    "details" : details,
                    "resourceType" : resource_type,
                }
            )
            
        pprint(response)
        
        if response == None:
            pprint("No Response was returned")
            return 
        if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
            print("Item added successfully")
            log_details = f"{details} {resource_type}"
            print(log_details)
            write_to_cloudwatch(log_details)
    except Exception as e:
        print(f"An Error Occured  {e}")
        write_to_cloudwatch(f"An Error Occured {response}")
        
def upload_to_s3(details):
      # call s3 bucket
    bucket = s3.Bucket('bucket_name') 
    # key path
    key = 'sample_inventory.csv'
    # download s3 csv file to lambda tmp folder
    local_file_name = '/tmp/test.csv' 
    s3.Bucket('bucket_name').download_file(key,local_file_name)
    # writing to csv file 
    with open(local_file_name, 'a') as csvfile: 
        # creating a csv writer object 
        csvwriter = csv.writer(csvfile) 
        # writing the data rows 
        csvwriter.writerows(details)
    # upload file from tmp to s3 key
    bucket.upload_file('/tmp/test.csv', key)

def lambda_handler(event, context):
    #Filter instances based on instance type
    instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['stopped','running','pending','stopping','shutting-down']}])
    types = ['t3','c4','m3']
    details = []
    pprint(instances)
    for instance in instances:
        instance_type = instance.instance_type
        if any(x in instance_type for x in types):
            details.append([instance.id,instance.instance_type, REGION])
    pprint(details)
    upload_to_dynamodb(details, "EC2")
   
        
def s3_name_inventory():
    buckets = [bucket.name for bucket in s3.buckets.all()]
    pprint(s3.buckets.all())
    pprint(buckets)
    bucket_list = []
    for bucket in buckets:
        bucket_list.append({"name": bucket})
    upload_to_dynamodb(bucket_list, "S3")
    
    
def vpc_endpoints_inventory():
    endpoints = ec2_client.describe_vpc_endpoints()
    pprint(endpoints["VpcEndpoints"])
    vpc_endpoints = endpoints["VpcEndpoints"]
    if vpc_endpoints == []:
        pprint("There are no VPC Endpoints found.")
        return
    upload_to_dynamodb(vpc_endpoints, "VPC Endpoints")
    
def security_group_inventory():
    groups = [{"name": group['GroupName']}
           for group in ec2_client.describe_security_groups()['SecurityGroups']]
    
    pprint(f"Security Groups {groups}")
    upload_to_dynamodb(groups, "Security Groups")
   
    
def autoscaling_inventory():
    response = autoscaling_client.describe_auto_scaling_groups()
    pprint(response)
    upload_to_dynamodb(response, "ASGs")

    
s3_name_inventory()
security_group_inventory()
# vpc_endpoints_inventory()
#lambda_handler(1,1)