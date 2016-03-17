from django import forms
from .models import Log_in
from django.core.exceptions import ValidationError

class LoginForm(forms.ModelForm):
    
    class Meta:
        model = Log_in
        fields = [
        "id",
        
        ]


class Log_inForm(forms.Form):
    content = forms.CharField(max_length=256)
