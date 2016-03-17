from __future__ import unicode_literals
from django.db import models



class Log_in(models.Model): 
    phonenumber = models.CharField(max_length=120)
    id = models.IntegerField(primary_key=True)
    username = models.CharField(max_length=120)
    password = models.CharField(max_length=32)
    timeaccess = models.DateTimeField(auto_now=False,auto_now_add=False)
    
    
    def __str__(self):
        return self.phonenumber