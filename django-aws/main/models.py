from django.db import models
from django.contrib.auth.models import User 


# TODO add more fields to the profile model and update the Profile forms and the HTML templates
class Profile(models.Model):
    profile_pic = models.ImageField(null=True, blank=True, default="favicon.ico", upload_to="images/")
    about_me = models.TextField(null=False)
    # create foreign key to user
    user = models.ForeignKey(User, max_length=10, on_delete=models.CASCADE, null=True, related_name="profile_user")
    created_at = models.DateTimeField(auto_now_add=True, editable=False)

    # TODO: create Meta class to set the ordering
    
    def __str__(self):
        return f"Profile for user {self.about_me}"
    