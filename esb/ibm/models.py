from __future__ import unicode_literals
from django.db import models
from fernet_fields import EncryptedCharField




class Log_in(models.Model): 
    
    phonenumber = models.CharField(max_length=120)
    id = models.IntegerField(primary_key=True)
    username = models.CharField(max_length=120)
    timeaccess = models.DateTimeField(auto_now=False,auto_now_add=False)
    testcasePass = EncryptedCharField(max_length=32, null=True)
    
    
    def __str__(self):
        return self.phonenumber