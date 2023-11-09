from django.contrib import admin
from .models import HomeInfoTable, UserInfoTable, HomeName
# Register your models here.
# add models to admin screen
admin.site.register(HomeInfoTable)
admin.site.register(UserInfoTable)
admin.site.register(HomeName)
