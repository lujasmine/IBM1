from __future__ import unicode_literals
from django.db import models
from fernet_fields import EncryptedCharField
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token
from django.conf import settings



class Log_in(models.Model): 
    
    phonenumber = models.CharField(max_length=120)
    id = models.IntegerField(primary_key=True)
    username = models.CharField(max_length=120)
    timeaccess = models.DateTimeField(auto_now=False,auto_now_add=False)
    testcasepass = EncryptedCharField(max_length=32, null=True)
    
    
    def __str__(self):
        return self.phonenumber
      



@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)