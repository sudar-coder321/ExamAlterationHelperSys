from django.contrib import admin
from django.urls import path
from django.conf.urls import url, include
from rest_framework.authtoken import views
from django.views.decorators.csrf import csrf_exempt
from graphene_django.views import GraphQLView
import examaltersys.schema
import admin_notifications
admin.site.site_header = "FacultyAssist"
admin.site.site_title = "FacultyAssist"
admin.site.index_title = "Exam Alteration Helper"
# admin.site.site_url = "http://127.0.0.1:8000/admin"
admin_notifications.autodiscover()

urlpatterns = [
    path('admin/', admin.site.urls),
    url(r'^graphql$', csrf_exempt(GraphQLView.as_view(graphiql=True))),
    path('examaltersys/', include('examaltersys.urls', namespace='examaltersys')),
    path('api-token-auth/', views.obtain_auth_token, name='api-token-auth'),
]
