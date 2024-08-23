from django.urls import path
from .views import SCIMUserView

urlpatterns = [
    path('scim/v2/Users/', SCIMUserView.as_view(), name='scim_users_list'),
    path('scim/v2/Users/<int:pk>/', SCIMUserView.as_view(), name='scim_user_detail'),
]
