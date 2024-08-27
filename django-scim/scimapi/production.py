from .settings import *  # noqa

DEBUG = False

# TODO: Add Dynamo DB

SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SECURE_SSL_REDIRECT = os.getenv("DJANGO_SECURE_SSL_REDIRECT", default=False)
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_HSTS_SECONDS = 60
SECURE_HSTS_INCLUDE_SUBDOMAINS = os.getenv("DJANGO_SECURE_HSTS_INCLUDE_SUBDOMAINS", default=True)
SECURE_HSTS_PRELOAD = os.getenv("DJANGO_SECURE_HSTS_PRELOAD", default=True)
SECURE_CONTENT_TYPE_NOSNIFF = os.getenv("DJANGO_SECURE_CONTENT_TYPE_NOSNIFF", default=True)
INSTALLED_APPS += ["storages"]  # noqa F405
AWS_STORAGE_BUCKET_NAME = os.getenv("AWS_STORAGE_BUCKET_NAME")
AWS_QUERYSTRING_AUTH = False
_AWS_EXPIRY = 60 * 60 * 24 * 7
AWS_S3_OBJECT_PARAMETERS = {"CacheControl": f"max-age={_AWS_EXPIRY}, s-maxage={_AWS_EXPIRY}, must-revalidate"}
AWS_S3_REGION_NAME = os.getenv("AWS_S3_REGION_NAME", default=None)
AWS_S3_CUSTOM_DOMAIN = os.getenv("DJANGO_AWS_S3_CUSTOM_DOMAIN", default=None)
AWS_S3_DOMAIN = AWS_S3_CUSTOM_DOMAIN or f"{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com"
STATICFILES_STORAGE = "django-scim.utils.StaticRootS3Boto3Storage"
#COLLECTFAST_STRATEGY = "collectfast.strategies.boto3.Boto3Strategy"
STATIC_URL = f"https://{AWS_S3_DOMAIN}/static/"
DEFAULT_FILE_STORAGE = "django-scim.utils.MediaRootS3Boto3Storage"
MEDIA_URL = f"https://{AWS_S3_DOMAIN}/media/"
MEDIAFILES_LOCATION = "/media"

STATICFILES_LOCATION = "/static"
TEMPLATES[-1]["OPTIONS"]["loaders"] = [  # type: ignore[index] # noqa F405
    (
        "django.template.loaders.cached.Loader",
        [
            "django.template.loaders.filesystem.Loader",
            "django.template.loaders.app_directories.Loader",
        ],
    )
]
