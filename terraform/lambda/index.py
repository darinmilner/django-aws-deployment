import boto3
import csv
import time
from pprint import pprint

ec2 = boto3.resource('ec2')
client = boto3.client('ec2')
s3 = boto3.resource('s3')
dynamodb = boto3.resource("dynamo-db")
logs = boto3.client("logs")
LOG_GROUP="Log-Group-Name"
LOG_STREAM="stream1"

def lambda_handler(event, context):
    #Filter instances based on instance type
    instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['stopped','running','pending','stopping','shutting-down']}])
    types = ['t3','c4','m3']
    details = []
    for instance in instances:
        instance_type = instance.instance_type
        if any(x in instance_type for x in types):
            details.append([instance.id,instance.instance_type,'us-west-2'])
    pprint(details)
  
    
    
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
    

def upload_to_dynamodb(details):
    table = dynamodb.Table("your-table-name")
    response = table.put_item(
        Item={
            "primary_key" : "table-pk",
            "details" : details,
        }
    )
    
    if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
        print("Item added successfully")
    else:
        print("An Error Occured")
        
def s3_inventory():
    buckets = [bucket.name for bucket in s3.buckets.all()]
    pprint(buckets)
    upload_to_dynamodb(buckets)
    

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