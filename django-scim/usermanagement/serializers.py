from rest_framework import serializers 
from .models import User, Group, GroupMember


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User 
        fields = "__all__"


class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group 
        fields = "__all__"
        
class GroupMemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = GroupMember
        fields = "__all__"