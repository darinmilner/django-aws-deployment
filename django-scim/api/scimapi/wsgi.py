import os

from django.core.wsgi import get_wsgi_application

# TODO: change to "scimapi.production" before deployment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'scimapi.local')

application = get_wsgi_application()
