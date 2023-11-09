from django.urls import path
from . import views
from .views import (
    HomeView,
    ListHomes,
    Login,
    OpenDoor,
    UpdateFromAPP,
    UpdateFromArduino,
    UserRegistration,
)

# URL configaration
urlpatterns = [
    path("homeinfo/<int:homename>", HomeView.as_view()),
    path("updatefromApp/<int:homename>", UpdateFromAPP.as_view()),
    path("updatefromArduino/<int:homename>", UpdateFromArduino.as_view()),
    path("listhomes/", ListHomes.as_view()),
    path("registoruser/", UserRegistration.as_view()),
    path("login/", Login.as_view()),
    path("openDoor/", OpenDoor.as_view()),
    path("sendTelegramMessage/", views.send_telegram_message),
]
