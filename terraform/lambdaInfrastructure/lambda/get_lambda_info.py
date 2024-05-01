import boto3 

client = boto3.client("lambda")
region = "us-east-1"

def get_lambda_info(function_name):
    response = client.get_function(
        FunctionName=function_name,
    )
    last_modified = response["Configuration"]["LastModified"]
    handler = response["Configuration"]["Handler"]
    logging_config = response["Configuration"]["LoggingConfig"] 
    role_arn = response["Configuration"]["Role"]
    func_arn = response["Configuration"]["FunctionArn"]

    try:
        layers = response["Configuration"]["Layers"]
        print(layers)
    except KeyError:
        print("The lambda does not have any layers attached.")

    try:
        vpc_config = response["Configuration"]["VpcConfig"]
        print(vpc_config)
    except KeyError:
        print("The lambda does not have a Vpc Config")
        
    try:
        queue = response["Configuration"]["DeadLetterConfig"]
        print(queue)
    except KeyError:
        print("The lambda has no queue config.")
        
    print(f"The lambda {function_name} was last modified: {last_modified}")
    print(f"The lambda's handler is {handler}")
    print(f"The lambd's logging config is {logging_config}")
    print(f"The lambda's role arn: {role_arn}")
    print(f"Lambda arn {func_arn}")
      
    tags = client.list_tags(
        Resource=func_arn,
    )
    print(tags["Tags"])
    
    # events = client.get_function_event_invoke_config(
    #     FunctionName=function_name,
    # )
    
    events = client.list_event_source_mappings(
        FunctionName=function_name,
    )
    
    print(events["EventSourceMappings"])
    # conf = client.get_function_url_config(
    #     FunctionName=func_arn,
    # )
    
    # print(f"Config ${conf}")
 
def get_layers_details():   
    layers = client.list_layers()
    print(layers["Layers"])

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

#loop through the lambda names and call the info function for each lambda
for lambda_name in all_lambdas:
    print(lambda_name)
    get_lambda_info(lambda_name)
    
get_layers_details()



 #aws lambda list-functions --max-items=10000 | jq -r '.Functions' | jq length
 
 

 
 