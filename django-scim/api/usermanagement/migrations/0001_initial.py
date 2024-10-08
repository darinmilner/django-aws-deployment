# Generated by Django 5.1 on 2024-08-24 13:48

import django.db.models.deletion
import django_extensions.db.fields
import usermanagement.adapters
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('created', django_extensions.db.fields.CreationDateTimeField(auto_now_add=True, verbose_name='created')),
                ('modified', django_extensions.db.fields.ModificationDateTimeField(auto_now=True, verbose_name='modified')),
                ('id', models.UUIDField(default=uuid.UUID('463ce5d1-71f9-4cd6-9fbd-b5fbcf4ac692'), editable=False, primary_key=True, serialize=False)),
                ('external_id', models.CharField(default=usermanagement.adapters.generate_external_id, max_length=100, unique=True)),
                ('username', models.CharField(blank=True, default=None, help_text='A unique identifier for the user.', max_length=254, null=True, unique=True, verbose_name='Username')),
                ('scim_username', models.CharField(blank=True, default=None, help_text='A unique identifier for the user.', max_length=254, null=True, unique=True, verbose_name='Scim Username')),
                ('email', models.EmailField(max_length=254, verbose_name='Email')),
                ('first_name', models.CharField(max_length=100, verbose_name='First Name')),
                ('last_name', models.CharField(max_length=100, verbose_name='Last Name')),
                ('is_staff', models.BooleanField(default=False)),
                ('is_admin', models.BooleanField(default=False)),
                ('company_name', models.CharField(max_length=100, verbose_name='Company Name')),
            ],
            options={
                'get_latest_by': 'modified',
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Group',
            fields=[
                ('id', models.UUIDField(default=uuid.UUID('a09cb5cb-2236-4e24-a4a1-b0e97dc9e7e6'), editable=False, primary_key=True, serialize=False)),
                ('external_id', models.CharField(default=usermanagement.adapters.generate_external_id, max_length=100, unique=True)),
                ('display_name', models.CharField(max_length=255, unique=True)),
                ('members', models.ManyToManyField(related_name='groups', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='GroupMember',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='usermanagement.group')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
