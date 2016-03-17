from __future__ import unicode_literals
from django.db import models
from passlib.hash import pbkdf2_sha256


class Log_in(models.Model): 
    phoneNumber = models.CharField(max_length=120)
    id = models.IntegerField(primary_key=True)
    userName = models.CharField(max_length=120)
    password = models.CharField(max_length=120)
    timeAccess = models.DateTimeField(auto_now=False,auto_now_add=False)
    
    
    def __str__(self):
        return self.phoneNumber