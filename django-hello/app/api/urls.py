from django.urls import path 
from .views import hello, test_django

urlpatterns = [
    path("hello/", hello),
    path("prod/hello/", hello),
    path("django/", test_django),
    path("prod/django/", test_django),
]