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
    context = {
    "object_list" : queryset,
    "title": "Welcome to Effortless and Secure Banking",
    }
    return HttpResponse("<h1>pass_input</h1>")
    
      
    
def final(request):
    if request.method == 'POST':
        phone_entry = request.POST.get('textfield', None)
        try:
            user = Log_in.objects.get(phoneNumber = phone_entry)
            name = user.userName
            context = {
            "user" : user,
            "name" : name,
            }
            return TemplateResponse(request, 'final.html', context)
        except Log_in.DoesNotExist:
           return TemplateResponse(request, 'index.html') 
    else:
        return render(request, 'final.html', context)
        
  
       
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
