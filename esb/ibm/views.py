from django.shortcuts import render_to_response, render, get_object_or_404
from django.template import RequestContext
from django.http import HttpResponse
from .models import Log_in
from django.forms.models import model_to_dict
from django.views.generic.edit import FormView
from django.template.response import TemplateResponse
from .forms import LoginForm


def index(request):
    return render(request, 'index.html')
    
      
    
def final(request):
    phone_entry = request.POST.get('textfield', None)
    value = phone_entry
    request.session['value'] = value
    print("~~~~~~~~~~~~~~~~~~" + value + "~~~~~~~~~~~~~~~~~~~~~~") #Testing
    try:
        user = Log_in.objects.get(phonenumber = phone_entry)
        name = user.username
        context = {
        "user" : user,
        "name" : name,
        }
        return TemplateResponse(request, 'final.html', context)
    except Log_in.DoesNotExist:
        print("~~~~~~~~~~~~~~~~~~" + value + "~~~~~~~~~~~~~~~~~~~~~~") #Testing
        return TemplateResponse(request, 'index.html', phonenumber) 

    return render(request, 'index.html', context, value)
        
        
def pass_input(request):
    if request.method == 'POST':
        pass_entry = request.POST.get('passfield', None)
        if 'value' in request.session:
            value = request.session['value']
            print("~~~~~~~~~~~~~~~~~~" + value + "~~~~~~~~~~~~~~~~~~~~~~") #Testing
        x = Log_in.objects.get(phonenumber = value)
        auth = x.testcasepass
        print("~~~~~~~~~~~~~~~~~~" + value + "~~~~~~~~~~~~~~~~~~~~~~") #Testing
        if auth == pass_entry:
            return TemplateResponse(request, 'pass_input.html')
        else:
            return HttpResponse()
    
        
def reg_pass(request):
    return render(request, 'reg_pass.html')
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
