import boto3 

client = boto3.client("lambda")

region = "us-east-1"
function_name = "Lambda1"



def get_lambda_info():
    response = client.get_function(
        FunctionName=function_name,
    )
    last_modified = response["Configuration"]["LastModified"]
    handler = response["Configuration"]["Handler"]
    logging_config = response["Configuration"]["LoggingConfig"]
    layers = None 

    try:
        layers = response["Configuration"]["Layers"]
    except KeyError:
        print("The lambda does not have any layers attached.")

    try:
        vpc_config = response["Configuration"]["VpcConfig"]
        print(vpc_config)
    except KeyError:
        print("The lambda does not have a Vpc Config")

    print(response)
    print(handler)
    print(logging_config)
    print(layers)

    try:
        queue = response["Configuration"]["DeadLetterConfig"]
    except KeyError:
        print("The lambda has no queue config.")

def get_all_functions():
    paginator = client.get_paginator("list_functions")

    res = paginator.paginate()
    all_functions = []
    for r in res:
        functions = r["Functions"]
    
        for function in functions:
            function_name = function["FunctionName"]
            all_functions.append(function_name)

    return all_functions
    
all_lambdas =  get_all_functions()
print(all_lambdas)

#TODO loop through the lambda names and call the info function for each lambda

 #aws lambda list-functions --max-items=10000 | jq -r '.Functions' | jq length
 
 

 
 