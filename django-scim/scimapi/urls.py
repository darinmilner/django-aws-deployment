from django.contrib import admin
from django.urls import path, include, re_path

from rest_framework import permissions
# from drf_yasg.views import get_schema_view
# from drf_yasg import openapi

# schema_view = get_schema_view(
#    openapi.Info(
#       title="Scim API",
#       default_version='v1',
#       description="Test description",
#    ),
#    public=True,
#    permission_classes=(permissions.AllowAny,),
# )


urlpatterns = [
    path(r"scim/v2/", include("django_scim.urls", namespace="scim")),
    path('admin/', admin.site.urls),
    path('', include('usermanagement.urls')),
   #  path('docs<format>/', schema_view.without_ui(cache_timeout=0), name='schema-json'),
   #  path('docs/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
   #  path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
]
