from django.conf.urls import url, include
from ibm import views

from .views import (
    index,
    pass_input,
    final,
    )

urlpatterns = [
    url(r'^index/$', index),
    url(r'^pass_input/$', pass_input),
    url(r'^final/$', final),
]