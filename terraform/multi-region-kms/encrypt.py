import boto3
import botocore

def encrypt_files_in_bucket(bucket_name, kms_key_id):
    s3 = boto3.client('s3')
    kms = boto3.client('kms')

    # Get a paginated list of all objects in the bucket
    paginator = s3.get_paginator('list_objects_v2')
    
    try:
        for page in paginator.paginate(Bucket=bucket_name):
            for obj in page.get('Contents', []):
                object_key = obj['Key']

                # Check if the object is a file (not a "folder")
                if not object_key.endswith('/'):
                    print(f"Object is {object_key}")
                    # Download the file
                    response = s3.get_object(Bucket=bucket_name, Key=object_key)
                    file_data = response['Body'].read()

                    # Encrypt the file data using the KMS key
                    encrypted_data = kms.encrypt(KeyId=kms_key_id, Plaintext=file_data)['CiphertextBlob']

                    # Upload the encrypted file back to S3, overwriting the original
                    s3.put_object(
                        Bucket=bucket_name,
                        Key=object_key,
                        Body=encrypted_data,
                        ServerSideEncryption='aws:kms',
                        SSEKMSKeyId=kms_key_id
                    )

                    print(f"Encrypted: {object_key}")
    except botocore.exceptions.ClientError as e:
        print(f"{object_key} could not be encrypted {e}")

if __name__ == "__main__":
    bucket_name = 'your-storage-bucket'  # Replace with your bucket name
    kms_key_id = 'yourKMSKeyArn'        # Replace with your KMS CMK ID
    encrypt_files_in_bucket(bucket_name, kms_key_id)
