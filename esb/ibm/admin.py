from django.contrib import admin

from .models import Log_in

class ibmAdmin(admin.ModelAdmin):
    list_display = ["id", "phoneNumber", "userName", "password","timeAccess"]
    search_fields = ["phoneNumber", "id"]
    class Meta:
        model = Log_in


admin.site.register(Log_in, ibmAdmin)