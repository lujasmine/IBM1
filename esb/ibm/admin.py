from django.contrib import admin

from .models import Log_in

class ibmAdmin(admin.ModelAdmin):
    list_display = ["id", "phonenumber", "username", "password","timeaccess"]
    search_fields = ["phonenumber", "id"]
    class Meta:
        model = Log_in


admin.site.register(Log_in, ibmAdmin)