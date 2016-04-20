from django.conf.urls import url, include
from ibm import views

from .views import (
    index,
    pass_input,
    final,
    reg_pass,
    list,
    )

urlpatterns = [
    url(r'^index/$', index),
    url(r'^pass_input/$', pass_input),
    url(r'^final/$', final),
    url(r'^reg_pass/$', reg_pass),
    url(r'^5ZVO0gX7Vy845sKhHwg0/$', list),
]