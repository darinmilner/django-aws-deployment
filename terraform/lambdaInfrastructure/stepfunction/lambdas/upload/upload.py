import os 
import boto3 
import logging
import json 

logger = logging.getLogger()
logger.setLevel("INFO")

# Create an S3 client
s3 = boto3.client('s3')

def lambda_handler(event, context):
    logger.info(f"Incoming event {event}")
    body = json.loads(event["body"])
    
    source_path = body["sourcePath"]
    bucket_name = body["bucketName"]
    try:
        # Check if the source path is a file or a folder
        if os.path.isfile(source_path):
            
            # If it's a file, upload the file
            file_name = os.path.basename(source_path)
            with open(source_path, 'rb') as file:
                s3.upload_fileobj(file, bucket_name, file_name)
            logger.info(f'File {source_path} uploaded to S3 bucket {bucket_name}')
        
        elif os.path.isdir(source_path):
            
            # If it's a folder, upload all files in the folder
            for root, _, files in os.walk(source_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    relative_path = os.path.relpath(file_path, source_path)
                    with open(file_path, 'rb') as file_data:
                        s3.upload_fileobj(file_data, bucket_name, relative_path)
                    print(f'File {file_path} uploaded to S3 bucket {bucket_name}')
        else:
            logger.error(f"Invalid source path: {source_path}")
            return {
                "statusCode" : 400,
                "message" : f"Invalid source path: {source_path}"
            }

        return {
            "statusCode" : 200,
            "message" : "File successfully uploaded.",
        }
    except Exception as e:
        logger.error(f'Error uploading files to S3 bucket {bucket_name}: {e}')
        return {
            "statusCode" : 500,
            "message" : f"Could not upload to bucket {bucket_name}."
        }