from rest_framework import serializers
from .models import HomeInfoTable, UserInfoTable, HomeName


class HomeTableSerializer(serializers.ModelSerializer):
    class Meta:
        model = HomeInfoTable
        fields = (
            "temp",
            "humudity",
            "desiredTemp",
            "home_name",
            "door_status",
            "fan_status",
            "light_status",
        )


class ArduinoInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = HomeInfoTable
        fields = ("temp", "humudity", "fan_status")


class AppInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = HomeInfoTable
        fields = ("fan_status", "light_status")


class CreateUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserInfoTable
        fields = (
            "username",
            "password",
            "card_number",
            "active_status",
            "home_name",
            "approve_status",
        )


class UserTableSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserInfoTable
        fields = "__all__"


class HomeNameTableSerializer(serializers.ModelSerializer):
    class Meta:
        model = HomeName
        fields = "__all__"
