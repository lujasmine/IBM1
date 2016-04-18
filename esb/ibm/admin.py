from django.contrib import admin

from .models import Log_in

class ibmAdmin(admin.ModelAdmin):
    list_display = ["phonenumber", "username","timeaccess","testcasepass"]
    search_fields = ["phonenumber"]
    class Meta:
        model = Log_in


admin.site.register(Log_in, ibmAdmin)