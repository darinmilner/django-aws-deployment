import requests 
import json 

api_url = "https://jsonplaceholder.typicode.com/todos"
todo = {"userId": 1, "title": "Invoke API", "completed": False}
headers = {"Content-Type": "application/json", "authenticationToken": "yourtoken"}

response = requests.post(api_url, data=json.dumps(todo), headers=headers)

print(response.json())
print(response.status_code)
