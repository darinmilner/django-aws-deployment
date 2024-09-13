
def write_to_cloudwatch(details, timestamp):  
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