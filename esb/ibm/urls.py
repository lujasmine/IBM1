from django.conf.urls import url, include
from django.conf import settings
from django.contrib.staticfiles import views
from ibm import views
from django.conf.urls.static import static


from .views import (
    index,
    pass_input,
    final,
    reg_pass,
    list,
    )

urlpatterns = [
    url(r'^$', index),
    url(r'^pass_input/$', pass_input),
    url(r'^final/$', final),
    url(r'^reg_pass/$', reg_pass),
    url(r'^p9qdULz6sU9mpFoyDiJovWY4hGy4eFLW3319uoKXq531FoPYnbi3VVutY5t8tDO3', list),
]
