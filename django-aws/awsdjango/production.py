from settings import *


# TODO: Create a production settings file and move AWS configuration to production settings 
AWS_ACCESS_KEY_ID = "" # TODO: store in .env file
AWS_SECRET_ACCESS_KEY = ""

AWS_STORAGE_BUCKET_NAME = "bucket-name-here"

# storage config for S3
STORAGES = {
    # Media file (image) management
    "default": {
        "BACKEND": "storages.backends.s3boto3.S3StaticStorage",
    },
    
    #css and JS file management
    "staticfiles": {
        "BACKEND": "storages.backends.s3boto3.S3StaticStorage",
    },
}

AWS_S3_CUSTOM_DOMAIN = "%s.s3.amazonaws.com" % AWS_STORAGE_BUCKET_NAME

AWS_S3_FILE_OVERWRITE = False 
