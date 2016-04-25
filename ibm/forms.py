from django import forms
from .models import Log_in
from django.core.exceptions import ValidationError

class LoginForm(forms.ModelForm):
    
    confirm_password = forms.CharField(widget=forms.PasswordInput())
    
    class Meta:
        model = Log_in
        fields = [
        "testcasepass",
        ]
        widgets = {
        
         'testcasePass': forms.PasswordInput(),
        
        }


