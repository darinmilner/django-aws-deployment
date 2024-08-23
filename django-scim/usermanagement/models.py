import uuid
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.conf import settings
from django.utils.translation import gettext_lazy as _

from django_extensions.db.models import TimeStampedModel
from django_scim.models import AbstractSCIMGroupMixin, AbstractSCIMUserMixin


class UserManager(BaseUserManager):
    def create_user(self, email, username, first_name, last_name, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email field must be set")
        email = self.normalize_email(email)
        user = self.model(email=email, username=username, first_name=first_name, last_name=last_name, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user 
    
    def create_superuser(self, username, password):
        user = self.model(username=username, password=password)
        
        user.is_staff = True 
        user.is_admin = True 
        user.set_password(password)
        user.save(using=self._db)
        return user 

    # def create_superuser(self, username, password=None, **extra_fields):
    #     extra_fields.setdefault('is_staff', True)
    #     extra_fields.setdefault('is_superuser', True)

    #     return self.create_user(username, password, **extra_fields)
    
    def get_by_natural_key(self, username: str):
        return self.get(username=username)
    
    
# This is overridden user model that uses SCIMUserMixin
# class User(AbstractSCIMUserMixin, TimeStampedModel, AbstractBaseUser):
class User(TimeStampedModel, AbstractBaseUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False) 
    username = models.CharField(
        _("Username"),
        max_length=254,
        null=True,
        blank=True,
        default=None,
        unique=True,
        help_text=_("A unique identifier for the user.")
    )
    email = models.EmailField(_("Email"))  
    first_name = models.CharField(_("First Name"), max_length=100,)  
    last_name = models.CharField(_("Last Name"), max_length=100, )   
    is_staff = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    
    USERNAME_FIELD = "username"
    objects = UserManager()
    
    def get_full_name(self):
        return self.first_name + " " + self.last_name
    
    def has_module_perms(self, app_label):
       return self.is_admin
   
    def has_perm(self, app_label):
       return self.is_admin
   
    @property
    def get_scimusername(self):
        return self.username
   
    @property
    def is_superuser(self):
        return self.is_admin
    
    def __str__(self):
        return self.username

    
    
# class Group(TimeStampedModel, AbstractSCIMGroupMixin):
#     # company = models.ForeignKey(
#     #     "usermanagement.Company",
#     #     on_delete=models.CASCADE,
#     # )
    
#     members = models.ManyToManyField(
#         settings.AUTH_USER_MODEL,
#         through="GroupMember",
#         through_fields=("group", "user")
#     )
    
#     @property
#     def name(self):
#         return self.scim_display_name

class Group(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    display_name = models.CharField(max_length=255, unique=True)
    members = models.ManyToManyField('User', related_name='groups')

    def __str__(self):
        return self.display_name
    

class GroupMember(models.Model):
    user = models.ForeignKey(
        to=settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )
    
    group = models.ForeignKey(
        to="usermanagement.Group",
        on_delete=models.CASCADE,
    )
    