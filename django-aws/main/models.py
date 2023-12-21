from django.db import models
from django.contrib.auth.models import User 
from django.urls import reverse 


class Profile(models.Model):
    profile_pic = models.ImageField(null=True, blank=True, default="favicon.ico", upload_to="images/")
    display_name = models.CharField(max_length=250)
    about_me = models.TextField(null=False)
    location = models.CharField(max_length=250)
    # create foreign key to user
    user = models.ForeignKey(User, max_length=10, on_delete=models.CASCADE, null=True, related_name="profile_user")
    created_at = models.DateTimeField(auto_now_add=True, editable=False)
    updated_at = models.DateTimeField(auto_now=True, editable=False)
    
    class Meta:
        ordering = ("-created_at",)
        
    def get_absolute_url(self):
        return reverse("profile-single", args=[self.user])
    
    def __str__(self):
        return f"Profile for user {self.display_name}-{self.location}"
    