from django.contrib import admin
from django.urls import path, include

# TODO: Create Health Check
urlpatterns = [
    path(r"scim/v2/", include("django_scim.urls", namespace="scim")),
    path('admin/', admin.site.urls),
    path('', include('usermanagement.urls')),
]
