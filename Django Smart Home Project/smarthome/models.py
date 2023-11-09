from django.db import models

# Create your models here.


class HomeName(models.Model):
    homeName = models.CharField(max_length=50)


class UserInfoTable(models.Model):
    username = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    card_number = models.CharField(max_length=255)
    active_status = models.BooleanField()
    home_name = models.ForeignKey(
        HomeName, null=True, on_delete=models.CASCADE)
    approve_status = models.BooleanField()


class HomeInfoTable(models.Model):
    temp = models.CharField(max_length=255)
    humudity = models.CharField(max_length=255)
    desiredTemp = models.CharField(max_length=255)
    home_name = models.ForeignKey(
        HomeName, null=True, on_delete=models.CASCADE)
    door_status = models.BooleanField()
    fan_status = models.BooleanField()
    light_status = models.BooleanField()
