import factory
from django.contrib.auth.models import User 
from main.models import Profile

class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User 
        
    password = "test"
    username = "test"
    is_superuser = True 
    is_staff = True 


class ProfileFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Profile 
        
    about_me = "test"
    