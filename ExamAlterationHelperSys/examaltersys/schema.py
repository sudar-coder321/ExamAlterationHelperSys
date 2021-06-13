import graphene
from graphene_django.registry import Registry
from graphene.relay import Node
from graphene import ObjectType, Connection, Node, Int
from examaltersys.models import FacultyCount, TakeDutyCount, Exam, User_T, ExamAllocation, Room, AssignDuty, TakeDuty, Course, RoomAllocation, NotificationCount, Answers, QuesAnsRelation, FreqQuestions, Grievances
from examaltersys.models import Notification as NotificationModel
from graphene_django.types import DjangoObjectType, ObjectType
from graphene_django.filter import DjangoFilterConnectionField
from django.contrib.auth.models import User
import graphql_jwt
from django_graphene_permissions import permissions_checker
from django_graphene_permissions.permissions import IsAuthenticated
from django.core.exceptions import *
from graphene import Time
import datetime
from django.contrib.auth import get_user_model


class ExtendedConnection(graphene.relay.Connection):
    class Meta:
        abstract = True

    total_count = graphene.Int()
    edge_count = graphene.Int()

    def resolve_total_count(root, info, **kwargs):
        return root.length

    def resolve_edge_count(root, info, **kwargs):
        return len(root.edges)


graphene.relay.Connection = ExtendedConnection


class CourseType(DjangoObjectType):
    class Meta:
        model = Course


class ExamAllocationType(DjangoObjectType):
    class Meta:
        model = ExamAllocation


class ExamType(DjangoObjectType):
    class Meta:
        model = Exam


class UserType(DjangoObjectType):
    class Meta:
        model = User


class UsertType(DjangoObjectType):
    class Meta:
        model = User_T


class FacultyCountType(DjangoObjectType):
    class Meta:
        model = FacultyCount
        fields = ['id']
        filter_fields = {
            'id':  ['exact', 'icontains'],
        }
        interfaces = (graphene.relay.Node, )
        connection_class = ExtendedConnection


class RoomType(DjangoObjectType):
    class Meta:
        model = Room


class RoomCountType(DjangoObjectType):
    class Meta:
        model = Room
        filter_fields = {
            'id':  ['exact', 'icontains'],
        }
        interfaces = (graphene.relay.Node, )
        connection_class = ExtendedConnection


class AssignDutyType(DjangoObjectType):
    class Meta:
        model = AssignDuty


class TakeDutyType(DjangoObjectType):
    class Meta:
        model = TakeDuty


class TakeDutyCountType(DjangoObjectType):
    class Meta:
        model = TakeDutyCount
        filter_fields = {
            'id':  ['exact', 'icontains'],
        }
        interfaces = (graphene.relay.Node, )
        connection_class = ExtendedConnection


class RoomAllocationType(DjangoObjectType):
    class Meta:
        model = RoomAllocation


class NotificationType(DjangoObjectType):
    class Meta:
        model = NotificationModel


class NotificationCountType(DjangoObjectType):
    class Meta:
        model = NotificationCount
        filter_fields = {
            'id':  ['exact', 'icontains'],
        }
        interfaces = (graphene.relay.Node, )
        connection_class = ExtendedConnection


class GrievancesType(DjangoObjectType):
    class Meta:
        model = Grievances


class FreqQuestionsType(DjangoObjectType):
    class Meta:
        model = FreqQuestions


class AnswersType(DjangoObjectType):
    class Meta:
        model = Answers


class QuesAnsRelationType(DjangoObjectType):
    class Meta:
        model = QuesAnsRelation


class Query(ObjectType):
    me = graphene.Field(UserType)
    usert = graphene.Field(UsertType, id=graphene.Int())
    exam = graphene.Field(ExamType, id=graphene.Int())
    user = graphene.Field(UserType, id=graphene.Int())
    room = graphene.Field(RoomType, id=graphene.Int())
    notification = graphene.Field(NotificationType, id=graphene.Int())
    exam_allocation = graphene.Field(ExamAllocationType, id=graphene.Int())
    assignduty = graphene.Field(AssignDutyType, id=graphene.Int())
    takeduty = graphene.Field(TakeDutyType, id=graphene.Int())
    grievance = graphene.Field(GrievancesType, id=graphene.Int())
    freqquestion = graphene.Field(FreqQuestionsType, id=graphene.Int())
    answer = graphene.Field(AnswersType, id=graphene.Int())
    quesAnsRelation = graphene.Field(QuesAnsRelationType, id=graphene.Int())
    course = graphene.Field(CourseType, id=graphene.Int())
    room_allocation = graphene.Field(RoomAllocationType, id=graphene.Int())
    exam_allocations = graphene.List(ExamAllocationType)
    room_allocations = graphene.List(RoomAllocationType)
    users = graphene.List(UserType)
    userts = graphene.List(UsertType)
    courses = graphene.List(CourseType)
    notifications = graphene.List(NotificationType)
    facultiescount = DjangoFilterConnectionField(FacultyCountType)
    exams = graphene.List(ExamType)
    rooms = graphene.List(RoomType)
    roomscount = DjangoFilterConnectionField(RoomCountType)
    assignduties = graphene.List(AssignDutyType)
    takeduties = graphene.List(TakeDutyType)
    takerscount = DjangoFilterConnectionField(TakeDutyCountType)
    notfscount = DjangoFilterConnectionField(NotificationCountType)
    grievances = graphene.List(GrievancesType)
    freqquestions = graphene.List(FreqQuestionsType)
    answers = graphene.List(AnswersType)
    quesAnsRelations = graphene.List(QuesAnsRelationType)

    def resolve_me(self, info):
        user = info.context.user
        if user.is_anonymous:
            raise Exception('Not logged in!')
        return user

    def resolve_faculties(self, info):
        users = User_T.objects.filter(type='faculty')
        return users

    def resolve_courses(self, info):
        courses = Course.objects.all()
        return courses

    def resolve_rooms(self, info):
        rooms = Room.objects.all()
        return rooms

    def resolve_exams(self, info):
        exams = Exam.objects.all()
        return exams

    def resolve_examduties(self, info, **kwargs):
        take_duty = ExamAllocation.objects.filter(username='faculty')
        return take_duty

    def resolve_exam_allocations(self, info):
        exam_allocations = ExamAllocation.objects.all()
        return exam_allocations

    def resolve_users(self, info):
        return get_user_model().objects.all()

    def resolve_userts(self, info):
        userts = User_T.objects.filter()
        return userts

    def resolve_notifications(self, info):
        notifications = NotificationModel.objects.all()
        return notifications

    def resolve_grievances(self, info):
        grievances = Grievances.objects.all()
        return grievances

    def resolve_freqquestions(self, info):
        freqquestions = FreqQuestions.objects.all()
        return freqquestions

    def resolve_answers(self, info):
        answers = Answers.objects.all()
        return answers

    def resolve_quesAnsRelations(self, info):
        quesansrelations = QuesAnsRelation.objects.all()
        return quesansrelations


class ExamInput(graphene.InputObjectType):
    exam_name = graphene.String()
    day = graphene.String()
    course_name = graphene.String()
    date = graphene.types.datetime.Date()
    start_time = graphene.types.datetime.Time()
    end_time = graphene.types.datetime.Time()
    duration = Time(required=True, time_input=Time(required=True))
    slot = graphene.String()


class RoomInput(graphene.InputObjectType):
    Room_ID = graphene.Int()
    Block = graphene.String()
    capacity = graphene.Int()


class NotificationInput(graphene.InputObjectType):
    username = graphene.String()
    notification = graphene.String()


class TakeDutyInput(graphene.InputObjectType):
    exam_id = graphene.Int()
    faculty_name = graphene.String()


class GrievancesInput(graphene.InputObjectType):
    faculty_name = graphene.String()
    grievance = graphene.String()

# 1


class AssignDuty(graphene.Mutation):
    ok = graphene.Boolean()
    takeduty = graphene.Field(TakeDutyType)

    class Arguments:
        id = graphene.ID()

    @ staticmethod
    @permissions_checker([IsAuthenticated])
    def mutate(root, info, input):
        ok = True
        takeduty_instance = TakeDuty(faculty=User_T.objects.get(input.faculty_name),
                                     exam=Exam.objects.get(
                                         input.exam_id))
        takeduty_instance.save()
        return AssignDuty(ok=ok, takeduty=takeduty_instance)

# 2


class DeleteDuty(graphene.Mutation):
    ok = graphene.Boolean()
    deleteduty = graphene.Field(TakeDutyType)

    class Arguments:
        id = graphene.ID()

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(self, info, id):
        ok = False
        deleteduty_inst = TakeDuty.objects.get(pk=id)
        if deleteduty_inst is not None:
            ok = True
            deleteduty_inst.delete()
        return DeleteDuty(ok=ok, deleteduty=deleteduty_inst)

# 3


class CreateExam(graphene.Mutation):
    class Arguments:
        input = ExamInput(required=True)

    ok = graphene.Boolean()
    exam = graphene.Field(ExamType)

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(root, info, input):
        ok = True
        exam_instance = Exam(exam_name=input.exam_name, day=input.day, course_name=input.course_name, date=input.date,
                             start_time=input.start_time,
                             end_time=input.end_time,
                             duration=input.duration,
                             slot=input.slot)
        exam_instance.save()
        return CreateExam(ok=ok, exam=exam_instance)


# 4


# 5


# quiz=Quiz.objects.get(pk=input.quiz),user=UserT.objects.get(pk=input.user)

class CreateGrievances(graphene.Mutation):
    class Arguments:
        input = GrievancesInput(required=True)
    ok = graphene.Boolean()
    grievance = graphene.Field(GrievancesType)

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(self, info, input=None):
        ok = False
        print(input.grievance)
        grievance_instance = Grievances(
            user=User_T.objects.get(user=User.objects.get(
                username=input.faculty_name)), grieve_text=input.grievance)
        if(grievance_instance):
            ok = True
            grievance_instance.save()
        return CreateGrievances(ok=ok, grievance=grievance_instance)


class DeleteExam(graphene.Mutation):
    class Arguments:
        id = graphene.ID()

    exam = graphene.Field(ExamType)
    ok = graphene.Boolean()

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(self, info, id):
        ok = False
        exam_inst = Exam.objects.get(pk=id)
        if exam_inst is not None:
            ok = True
            exam_inst.delete()
        return DeleteExam(ok=ok, exam=exam_inst)

# 7


class UpdateExam(graphene.Mutation):
    class Arguments:
        input = ExamInput(required=True)
    ok = graphene.Boolean()
    exam = graphene.Field(ExamType)

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(self, info, input):
        exam_instance = Exam.objects.filter(
            exam_name=input.exam_name, date=input.date, start_time=input.start_time, end_time=input.end_time)
        if(exam_instance):
            ok = True
            exam_instance.update(exam_name=input.exam_name, day=input.day, course_name=input.course_name, date=input.date,
                                 start_time=input.start_time,
                                 end_time=input.end_time,
                                 duration=input.duration,
                                 slot=input.slot)

            exam_instance = exam_instance[0]
            exam_instance.save()
            return UpdateExam(ok=ok, exam=exam_instance)

# 8


class UpdateRoom(graphene.Mutation):
    ok = graphene.Boolean()
    room = graphene.Field(ExamType)

    class Arguments:
        room_data = RoomInput(required=True)

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(self, info, room_data):
        room_instance = Room.objects.filter(
            Room_ID=room_data.Room_ID, Block=room_data.Block, capacity=room_data.capacity)
        if(room_instance):
            ok = True
            room_instance.update(
                Room_ID=room_data.Room_ID, Block=room_data.Block, capacity=room_data.capacity)
            room_instance = room_instance[0]
            room_instance.save()
            return UpdateRoom(ok=ok, room=room_instance)


class CreateNotification(graphene.Mutation):
    notif = graphene.Field(NotificationType)
    ok = graphene.Boolean()

    class Arguments:
        input = NotificationInput(required=True)

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(self, info, input):
        ok = True
        notf_instance = NotificationModel(user=User_T.objects.get(
            input.username), notification=input.notification)
        notf_instance.save()
        return CreateNotification(ok=ok, notif=notf_instance)


class DeleteNotification(graphene.Mutation):
    notification = graphene.Field(NotificationType)
    ok = graphene.Boolean()

    class Arguments:
        id = graphene.ID()

    @ staticmethod
    @ permissions_checker([IsAuthenticated])
    def mutate(self, info, id):
        ok = False
        notification_inst = NotificationModel.objects.get(pk=id)
        if notification_inst is not None:
            ok = True
            notification_inst.delete()
        return DeleteNotification(notification=notification_inst)


class Mutation(graphene.ObjectType):
    create_exam = CreateExam.Field()
    update_exam = UpdateExam.Field()
    update_room = UpdateRoom.Field()
    delete_exam = DeleteExam.Field()
    assign_duty = AssignDuty.Field()
    delete_duty = DeleteDuty.Field()
    del_notification = DeleteNotification.Field()
    create_notification = CreateNotification.Field()
    create_grievances = CreateGrievances.Field()
    token_auth = graphql_jwt.ObtainJSONWebToken.Field()
    verify_token = graphql_jwt.Verify.Field()
    refresh_token = graphql_jwt.Refresh.Field()


schema = graphene.Schema(query=Query, mutation=Mutation)
