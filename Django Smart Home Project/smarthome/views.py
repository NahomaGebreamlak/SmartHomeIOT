from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from smarthome.models import HomeInfoTable, HomeName, UserInfoTable
from smarthome.serializers import (
    AppInfoSerializer,
    ArduinoInfoSerializer,
    CreateUserSerializer,
    HomeNameTableSerializer,
    HomeTableSerializer,
    UserTableSerializer,
)
import requests
from telegram import Bot
import json


class ListHomes(APIView):
    def get(self, request):
        items = HomeName.objects.all()
        serializer = HomeNameTableSerializer(items, many=True)
        return Response(serializer.data)


class HomeView(APIView):
    # get Info about a specific home
    def get(self, request, homename):
        items = HomeInfoTable.objects.get(home_name=int(homename))
        serializer = HomeTableSerializer(items, many=False)
        return Response(serializer.data)

    def put(self, request, homename):
        if request.method == "PUT":
            home_info = HomeInfoTable.objects.get(home_name=homename)
            serializer = AppInfoSerializer(home_info, data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# update info from Arduino to server
class UpdateFromArduino(APIView):
    def put(self, request, homename):
        if request.method == "PUT":
            home_info = HomeInfoTable.objects.get(home_name=homename)
            serializer = ArduinoInfoSerializer(home_info, data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# update info from Android to server
class UpdateFromAPP(APIView):
    def put(self, request, homename):
        if request.method == "PUT":
            home_info = HomeInfoTable.objects.get(home_name=homename)
            serializer = AppInfoSerializer(home_info, data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# class SendTelegramMessage(APIView):
#     def post(self, request):
#         if request.method == "POST":
#             chatID = request.data.get("chatId")
#             telToken = request.data.get("token")
#             message = "Your Home is Not Safe But it works"

#             if message:
#                 bot = Bot(token=telToken)
#                 response = bot.send_message(chat_id=chatID, text=message)
#                 return json.dump(response, skipkeys=True)
#             # JsonResponse({'status': 'success', 'message': 'Message sent successfully.'})
#             else:
#                 return JsonResponse(
#                     {"status": "error", "message": "No message provided."}
#                 )


def send_telegram_message(request):
    if request.method == "POST":
        chat_id = request.POST.get("chatId")
        token = request.POST.get("token")
        message = "You home is not safe"
        if chat_id and token:
            # bot = Bot(token=token)
            # bot.send_message(chat_id=chat_id, text=message)

            request.get(
                "https://api.telegram.org/bot5946599160:AAE_T4zsAgdoJ56ScR0wyZBcwHf28Zsyfhg/sendMessage?chat_id=789630357&text=Nahoma are u From Django"
            )
            return JsonResponse(
                {"success": True, "message": "Telegram message sent successfully"}
            )
        else:
            return JsonResponse(
                {
                    "success": False,
                    "message": "chat_id and text parameters are required",
                }
            )
    else:
        return JsonResponse(
            {"success": False, "message": "Only POST requests are allowed"}
        )


class UserRegistration(APIView):
    def post(self, request):
        serializer = CreateUserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(
                {"status": "success", "data": serializer.data},
                status=status.HTTP_200_OK,
            )
        else:
            return Response(
                {"status": "error", "data": serializer.errors},
                status=status.HTTP_400_BAD_REQUEST,
            )


class Login(APIView):
    def post(self, request):
        if request.method == "POST":
            username = request.data.get("username")
            password = request.data.get("password")
            try:
                home_model = UserInfoTable.objects.get(
                    username=username, password=password
                )
                return Response({"success": True})
            except UserInfoTable.DoesNotExist:
                return Response({"success": False}, status=status.HTTP_404_NOT_FOUND)


class OpenDoor(APIView):
    def post(self, request):
        if request.method == "POST":
            cardNumber = request.data.get("cardNumber")
            home_id = request.data.get("homeId")
            try:
                home_model = UserInfoTable.objects.get(
                    card_number=cardNumber, home_name=home_id
                )
                return Response({"open": True})
            except UserInfoTable.DoesNotExist:
                return Response({"open": False}, status=status.HTTP_404_NOT_FOUND)
