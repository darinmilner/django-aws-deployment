from rest_framework.exceptions import APIException
from rest_framework import status


class SCIMNotFound(APIException):
    status_code = 404
    default_detail = 'Resource not found.'
    default_code = 'not_found'

class SCIMConflict(APIException):
    status_code = 409
    default_detail = 'Resource already exists.'
    default_code = 'conflict'

class SCIMBadRequest(APIException):
    status_code = status.HTTP_400_BAD_REQUEST
    default_detail = 'Bad request.'
    default_code = 'bad_request'