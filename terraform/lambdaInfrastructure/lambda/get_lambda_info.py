import boto3 

client = boto3.client("lambda")

region = "us-east-1"
function_name = "Lambda1"

response = client.get_function(
    FunctionName=function_name,
)

last_modified = response["Configuration"]["LastModified"]
handler = response["Configuration"]["Handler"]
logging_config = response["Configuration"]["LoggingConfig"]
# layers = response["Configuration"]["Layers"]
try:
    vpc_config = response["Configuration"]["VpcConfig"]
    print(vpc_config)
except:
    print("The lambda does not have a Vpc Config")

print(response)
print(handler)
print(logging_config)
# print(layers)

def get_all_functions():
    functions = client.list_functions()
    print(f"Lambda functions ${functions}")
    
get_all_functions()