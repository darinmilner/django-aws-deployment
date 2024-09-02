from django.db.models import Q
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import User, Group
from .serializers import UserSerializer, GroupSerializer
from .exceptions import SCIMConflict, SCIMNotFound, SCIMBadRequest
from rest_framework.exceptions import APIException

class SCIMUserView(APIView):

    def get(self, request, pk=None):
        print(pk)
        try:
            if pk:
                str_pk = str(pk)
                user = User.objects.get(pk=str_pk)
                serializer = UserSerializer(user)
                return Response(serializer.data)
            else:
                users = User.objects.all()
                serializer = UserSerializer(users, many=True)
                return Response(serializer.data)
        except User.DoesNotExist:
            raise SCIMNotFound()
        except Exception as e:
            raise SCIMBadRequest(str(e))

    def post(self, request):
        try:
            serializer = UserSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            raise SCIMConflict(str(e))

    def put(self, request, pk):
        try:
            user = User.objects.get(pk=pk)
            serializer = UserSerializer(user, data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            raise SCIMBadRequest(serializer.errors)
        except User.DoesNotExist:
            raise SCIMNotFound()
        except Exception as e:
            raise SCIMBadRequest(str(e))

    def delete(self, request, pk):
        try:
            user = User.objects.get(pk=pk)
            user.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except User.DoesNotExist:
            raise SCIMNotFound()
        except Exception as e:
            raise SCIMBadRequest(str(e))
        
class SCIMGroupView(APIView):
    def get(self, request, pk=None):
        try:
            if pk:
                str_pk = str(pk)
                group = Group.objects.get(pk=str_pk)
                serializer = GroupSerializer(group)
                return Response(serializer.data)
            else:
                groups = Group.objects.all()
                serializer = GroupSerializer(groups, many=True)
                return Response(serializer.data)
        except Group.DoesNotExist:
            raise SCIMNotFound(detail=f"Resource {pk} not found")
        except Exception as e:
            raise APIException(detail=str(e))

    def post(self, request):
        serializer = GroupSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            group = Group.objects.get(pk=pk)
        except Group.DoesNotExist:
            raise SCIMNotFound(detail=f"Resource {pk} not found")

        serializer = GroupSerializer(group, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        try:
            group = Group.objects.get(pk=pk)
            group.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Group.DoesNotExist:
            raise SCIMNotFound(detail=f"Resource {pk} not found")


def query_user_by_company_name(request):
    company_name = request.GET.get("companyname")
    users = User.objects.get(Q(company_name=company_name))
    serializer = UserSerializer(users, many=True)
    return Response(serializer.data)