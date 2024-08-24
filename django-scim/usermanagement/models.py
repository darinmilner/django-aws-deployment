import uuid
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.conf import settings
from django.utils.translation import gettext_lazy as _

from django_extensions.db.models import TimeStampedModel
from django_scim.models import AbstractSCIMGroupMixin, AbstractSCIMUserMixin
from .adapters import generate_external_id


class UserManager(BaseUserManager):
    def create_user(self, email, username, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email field must be set")
        if not username:
            raise ValueError("The Username field must be set")
        email = self.normalize_email(email)
       
        user = self.model(email=email, username=username, **extra_fields)
        user.scim_username = username 
        user.set_password(password)
        user.save(using=self._db)
        return user 
    
    def create_superuser(self, username, password):
        user = self.model(username=username, password=password)
        
        user.is_staff = True 
        user.is_admin = True 
        user.scim_username = username
        user.set_password(password)
        user.save(using=self._db)
        return user 
    
    def get_by_natural_key(self, username: str):
        return self.get(username=username)
    
    
# class User(AbstractSCIMUserMixin, TimeStampedModel, AbstractBaseUser):
class User(TimeStampedModel, AbstractBaseUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4(), editable=False) 
    external_id = models.CharField(max_length=100, unique=True, default=generate_external_id)
    username = models.CharField(
        _("Username"),
        max_length=254,
        null=True,
        blank=True,
        default=None,
        unique=True,
        help_text=_("A unique identifier for the user.")
    )
    scim_username = models.CharField(
        _("Scim Username"),
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
    company_name = models.CharField(_("Company Name"), max_length=100,)
    
    USERNAME_FIELD = "username"
    objects = UserManager()
    
    def get_full_name(self):
        return self.first_name + " " + self.last_name
    
    def has_module_perms(self, app_label):
       return self.is_admin
   
    def has_perm(self, app_label):
       return self.is_admin
   
    @property
    def get_scim_username(self):
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
    id = models.UUIDField(primary_key=True, default=uuid.uuid4(), editable=False)
    external_id = models.CharField(max_length=100, unique=True, default=generate_external_id)
    display_name = models.CharField(max_length=255, unique=True)
    members = models.ManyToManyField('User', related_name='groups')

    def __str__(self):
        return self.display_name
    

class GroupMember(models.Model):
    user = models.ForeignKey(
        to="User",
        on_delete=models.CASCADE,
    )
    
    group = models.ForeignKey(
        to="Group",
        on_delete=models.CASCADE,
    )
    