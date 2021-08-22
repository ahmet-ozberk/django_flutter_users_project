from django.contrib import admin
from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from django.conf.urls import url
from django.contrib import admin
from FastApi import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('users/', views.UserModelView.as_view()),
]
