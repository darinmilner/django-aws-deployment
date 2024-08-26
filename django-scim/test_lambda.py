import json
import os


def handler(event, context):
    try:
        import django
    except:
        print("could not import django")

    print(os.listdir("/opt"))
    print('request: {}'.format(json.dumps(event)))
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'text/plain'},
        'body': 'Hello, CDK! You have hit {}\n'.format(event['path']),
    }
