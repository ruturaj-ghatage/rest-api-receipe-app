from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from django.utils.translation import gettext_lazy as _

from core import models

class UserAdmin(BaseUserAdmin):

    ordering = ['id']
    list_display = ['email', 'name']

    #This will result in an error when you click on the link for modifying object this is because 
    #the fields set for model and BaseUserAdmin are different. So we modify the fields

    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        (
            _('Permissions'),{
                'fields': (
                    'is_active',
                    'is_staff',
                    'is_superuser',
                )
            }
        ),
        (
            _('Important date'), {
                'fields' : (
                    'last_login',
                )
            }
        )
    )

    readonly_fields = ['last_login']

    add_fieldsets = (
        (None, {
            'classes' : ('wide',),
            'fields' : (
                'email',
                'password1',
                'password2',
                'name',
                'is_active',
                'is_staff',
                'is_superuser',
            ) 

        }),
    )

admin.site.register(models.User, UserAdmin)