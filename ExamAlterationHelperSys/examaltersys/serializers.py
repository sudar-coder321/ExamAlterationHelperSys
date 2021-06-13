from django.contrib.auth.models import User
from rest_framework import serializers
from rest_framework.validators import UniqueTogetherValidator
from .models import User_T


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'first_name',
                  'last_name')
        validators = [
            UniqueTogetherValidator(
                queryset=User.objects.all(),
                fields=['username', 'email']
            )
        ]

    def create(self, validated_data):
        data = {'username': validated_data['username'], 'first_name': validated_data['first_name'],
                'last_name': validated_data['last_name'], "email": validated_data['email']}
        user = User.objects.create_user(**data)
        user.set_password(validated_data['password'])
        if validated_data['type'] and (validated_data['type'] == "ExamDutyOfficer" or validated_data['type'] == "Faculty" or validated_data['type'] == "Admin"):
            User_T.objects.create(user=user, type=validated_data['type'])
        user.save()
        return user


class UserTSerializer(serializers.ModelSerializer):
    def getName(self, obj):
        return obj.user.username

    def getpassword(self, obj):
        return obj.user.password

    def getEmail(self, obj):
        return obj.user.email

    def getType(self, obj):
        return obj.user.type

    def getDOB(self, obj):
        return obj.user.DOB

    def getphno(self, obj):
        return obj.user.phno

    username = serializers.SerializerMethodField("getName")
    pas = serializers.SerializerMethodField("getpassword")
    type_ = serializers.SerializerMethodField("gettype")
    email = serializers.SerializerMethodField("getEmail")
    phno = serializers.SerializerMethodField("getphno")
    DOB = serializers.SerializerMethodField("getDOB")

    class Meta:
        model = User_T
        fields = ('username', 'password', 'type_', 'email', 'phno', 'DOB')
        validators = [
            UniqueTogetherValidator(
                queryset=User.objects.all(),
                fields=['username', 'email']
            )
        ]
