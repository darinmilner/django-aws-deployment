from rest_framework.exceptions import APIException

class SCIMNotFound(APIException):
    status_code = 404
    default_detail = 'Resource not found.'
    default_code = 'not_found'

class SCIMConflict(APIException):
    status_code = 409
    default_detail = 'Resource already exists.'
    default_code = 'conflict'
