from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import *
from .serializers import *

class UserModelView(APIView):
    def get(self, request):
        users = UserModel.objects.all()
        serializer = UserModelSerializer(users,many=True)
        return Response({'status':status.HTTP_200_OK==200 if True else False,'users':serializer.data})

    def post(self, request):
        serializer = UserModelSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            message = ""
            if status.HTTP_201_CREATED == 201:
                message = "Users başarıyla eklendi."
            else:
                message = "Users eklenirken bir sorun oluştu."
            return Response({'status':status.HTTP_201_CREATED == 201 if True else False,'message' : message}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

