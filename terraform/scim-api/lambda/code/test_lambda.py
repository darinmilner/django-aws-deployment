import json
import os


def lambda_handler(event, context):
    print(event)
    try:
        import boto3
        print("boto3 imported")
        client = boto3.client("dynamodb")
    except Exception as e:
        print("could not import boto3")
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'text/plain'},
            'body': "Boto3 was not imported",
        }
    try:
        import django
        print("Django has been imported")
    except Exception as e:
        print(f"could not import django {e}")
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'text/plain'},
            'body': "Django was not imported",
    }
        
    try:
        import rest_framework
        print("Django rest framework has been imported")
    except Exception as e:
        print(f"could not import django restframework {e}")
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'text/plain'},
            'body': "Django Rest Framework was not imported",
    }
        
    try:
        import dotenv
        print("Django dotenv has been imported")
    except Exception as e:
        print(f"could not import django dotenv {e}")
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'text/plain'},
            'body': "Django Rest Framework was not imported",
    }
        
    try:
        import django_scim
        print("Django scim has been imported")
    except Exception as e:
        print(f"could not import django scim {e}")
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'text/plain'},
            'body': "Django scim was not imported",
    }

    print(os.listdir("/opt"))
    print('request: {}'.format(json.dumps(event)))
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'text/plain'},
        'body': 'Hello, ALB is working. Layers are working',
    }
