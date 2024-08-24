from django.urls import path
from .views import SCIMUserView, SCIMGroupView

urlpatterns = [
    path('scim/v2/Users/', SCIMUserView.as_view(), name='scim-users-list'),
    path('scim/v2/Users/<uuid:pk>/', SCIMUserView.as_view(), name='scim-user-detail'),
    path('scim/v2/Groups/', SCIMGroupView.as_view(), name='scim-groups-list'),
    path('scim/v2/Groups/<uuid:pk>/', SCIMGroupView.as_view(), name='scim-group-detail'),
]
