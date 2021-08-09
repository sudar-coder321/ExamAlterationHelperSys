from django.urls import path
from .views import UserRecordView, UserTRecordView


app_name = 'examaltersys'
urlpatterns = [
    path('user/', UserRecordView.as_view(), name='users'),
    path('usert/', UserTRecordView.as_view(), name='users'),
]
