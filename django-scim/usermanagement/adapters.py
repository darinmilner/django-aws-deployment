from django_scim import exceptions as scim_exceptions
from django_scim.adapters import SCIMUser
from oauthlib.common import UNICODE_ASCII_CHARACTER_SET, generate_client_id

 
class BaseHashGenerator:
    def hash(self):
        raise NotImplementedError()       
        
class ClientIdGenerator(BaseHashGenerator):
    def hash(self):
        return generate_client_id(length=40, chars=UNICODE_ASCII_CHARACTER_SET)
    
    
def generate_external_id():
    """
        Generates an external_id for Scim Resources
    """
    id_generator = ClientIdGenerator()
    return id_generator.hash()


class ScimUser(SCIMUser):
    password_changed = False 
    activity_changed = False 
    
    def __init__(self, obj, request=None):
        super().__init__(obj, request)
        self._from_dict_copy = None 
