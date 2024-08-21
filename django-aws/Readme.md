Django and AWS

Create a virtual environment and activate it and install django

create a Django app

Django has authentication built in and it can be configured to use outside auth providers such as
scim.  Scim allows for different auth providers such as Okta.
Scim helps manage different groups (Similar to AWS Cognito) and it standardizes the format of data returned by different auth providers.
Scim is open source and is often used in enterprise settings.

Django has a library that helps with integrated scim.  It supports Postgres database though other databases could be configured in django.

Install django scim
pip install django-scim2

Then add the django_scim app to INSTALLED_APPS in your Django’s settings:

INSTALLED_APPS = (
    ...
    'django_scim',
)
Add the appropriate middleware to authorize or deny the SCIM calls:

MIDDLEWARE_CLASSES = (
    ...
    'django_scim.middleware.SCIMAuthCheckMiddleware',
    ...
)

Make sure to place this middleware after authentication middleware as this middleware simply checks request.user.is_anonymous() to determine if the SCIM request should be allowed or denied.

Add the necessary url patterns to your root urls.py file. Please note that the namespace is mandatory and must be named scim:

urlpatterns = [
    ...
    path('scim/v2/', include('django_scim.urls')),
]
Finally, add settings appropriate for you app to your settings.py file:

SCIM_SERVICE_PROVIDER = {
    'NETLOC': 'localhost',
    'AUTHENTICATION_SCHEMES': [
        {
            'type': 'oauth2',
            'name': 'OAuth 2',
            'description': 'Oauth 2 implemented with bearer token',
        },
    ],
}

Adapters are used to convert a Django object to the correct scim format
An adapter is instantiated with a model instance. Eg:

user = get_user_model().objects.get(id=1)
scim_user = SCIMUser(user)

scim models come with more functionality as described in the django scim docs 
https://django-scim2.readthedocs.io/en/latest/adapters.html

An example of how the scim models are implemented in django
https://github.com/15five/django-scim2/blob/master/demo/app/adapters.py

Djangos user model can be configured using scim
This example overrides the username field in the django application using the AbstractScimUser base class
found in the django scim package.   
Why override this? Can't we just use what the AbstractSCIMUser mixin
gives us? The USERNAME_FIELD needs to be "unique" and for flexibility, 
AbstractSCIMUser.scim_username is not unique by default.

There is also a Group class in the django scim package that helps create and manage scim user groups

class User(AbstractSCIMUser, TimeStampedModel, AbstractBaseUser):
    company = models.ForeignKey(
        'app.Company',
        on_delete=models.CASCADE,
    )

    # override the username
    scim_username = models.CharField(
        _('SCIM Username'),
        max_length=254,
        null=True,
        blank=True,
        default=None,
        unique=True,
        help_text=_("A service provider's unique identifier for the user"),
    )

    email = models.EmailField(
        _('Email'),
    )

    first_name = models.CharField(
        _('First Name'),
        max_length=100,
    )

    last_name = models.CharField(
        _('Last Name'),
        max_length=100,
    )

    USERNAME_FIELD = 'scim_username'

    def get_full_name(self):
        return self.first_name + ' ' + self.last_name

    def get_short_name(self):
        return self.first_name + (' ' + self.last_name[0] if self.last_name else '')

Scim JSON object
