from django_scim import exceptions as scim_exceptions
from django_scim.adapters import SCIMUser
from django.db import models 

    
class ScimUser(SCIMUser):
    password_changed = False 
    activity_changed = False 
    
    def __init__(self, obj, request=None):
        super().__init__(obj, request)
        self._from_dict_copy = None 