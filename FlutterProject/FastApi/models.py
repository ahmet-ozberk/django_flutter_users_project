from django.db import models
from django.db.models.fields import CharField


# Create your models here.
class UserModel(models.Model):
    name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    age = models.CharField(max_length=3)
    university = models.CharField(max_length=50)
    job = models.CharField(max_length=20)

    def __str__(self):
        return self.name