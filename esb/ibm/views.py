from django.shortcuts import render_to_response, render, get_object_or_404
from django.template import RequestContext
from django.http import HttpResponse
from .models import Log_in
from .forms import LoginForm
from django.forms.models import model_to_dict
from django.views.generic.edit import FormView
from .forms import Log_inForm
from django.template.response import TemplateResponse


def index(request):
    return render(request, 'index.html')

    
def pass_input(request):
    if request.method == 'POST':
        pass_entry = request.POST.get('passfield', None)
        try:
            nextuser = Log_in.objects.get(password = pass_entry)
            return TemplateResponse(request, 'pass_input.html')
        except Log_in.DoesNotExist:
           return HttpResponse()
    else:
        return HttpResponse()
    
      
    
def final(request):
    if request.method == 'POST':
        phone_entry = request.POST.get('textfield', None)
        try:
            user = Log_in.objects.get(phonenumber = phone_entry)
            name = user.username
            context = {
            "user" : user,
            "name" : name,
            }
            return TemplateResponse(request, 'final.html', context)
        except Log_in.DoesNotExist:
           return TemplateResponse(request, 'index.html') 
    else:
        return render(request, 'index.html', context)
        
  
       
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
