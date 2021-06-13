from django.test import TestCase

from django.db import models, IntegrityError
from django.core.exceptions import ValidationError
from django.contrib.auth.models import User
from examaltersys.models import Exam, User_T, ExamAllocation, Room, AssignDuty, TakeDuty, Course, Notification, RoomAllocation
from dateutil import tz
from datetime import datetime

utc_tz = tz.gettz('UTC')
india_tz = tz.gettz('Asia/Kolkata')
date_string = "2018-12-24T02:35:16-08:00"
utc = datetime.strptime(
    date_string[:date_string.rindex('-')], '%Y-%m-%dT%H:%M:%S')
utc = utc.replace(tzinfo=utc_tz)
ito = utc.astimezone(india_tz)
itoo = ito.replace(tzinfo=None)


class TestModels(TestCase):
    def setUp(self):
        self.user1 = User.objects.create(username='Ravi', password='yotta321')
        self.userf1 = User_T.objects.create(user=self.user1, type='faculty')

        self.user2 = User.objects.create(username='Kiran', password='beta453')
        self.userf2 = User_T.objects.create(user=self.user2, type='faculty')

        self.user3 = User.objects.create(
            username='Rajesh', password='bytoxe567')
        self.usere1 = User_T.objects.create(
            user=self.user3, type='examdutyofficer')

        self.user4 = User.objects.create(username='Kanna', password='geton786')
        self.usere2 = User_T.objects.create(
            user=self.user4, type='examdutyofficer')

        self.user5 = User.objects.create(
            username='Mohan', password='kentucky89')
        self.usera3 = User_T.objects.create(user=self.user5, type='admin')

        self.course1 = Course.objects.create(
            Course_ID='15CSE123', Course_name="maths")
        self.course2 = Course.objects.create(
            Course_ID='15CSE102', Course_name="physics")
        # self.clas1=Clas.objects.create(class_name="3C")
        self.room1 = Room.objects.create(
            Room_ID='A-123', Block='Academic Block-2', capacity=120)
        self.room2 = Room.objects.create(
            Room_ID='A-321', Block='Academic Block-1', capacity=100)

        self.exam1 = Exam.objects.create(exam_name='periodical2-1st', day='Tuesday', Date='2021-04-07',
                                         start_time='09:00:00', end_time='10:00:00', duration=None, slot='Morning')
        self.exam2 = Exam.objects.create(exam_name='periodical2-1st', day='Wednesday', Date='2021-04-06',
                                         start_time='02:00:00', end_time='03:00:00', duration=None, slot='Afternoon')

        self.room_allocation1 = RoomAllocation.objects.create(
            room=self.room1, faculty=self.userf2)
        self.room_allocation2 = RoomAllocation.objects.create(
            room=self.room2, faculty=self.userf1)

        self.exam_allocation1 = ExamAllocation.objects.create(
            exam=self.exam1, course=self.course1, room=self.room1)
        self.exam_allocation2 = ExamAllocation.objects.create(
            exam=self.exam2, course=self.course2, room=self.room2)

        self.assignduty = AssignDuty.objects.create(
            exam=self.exam_allocation1, edo=self.usere1)

        self.takesduty = TakeDuty.objects.create(
            exam=self.exam_allocation2, faculty=self.userf1)

    def test_User_T_is_assigned_faculty_on_creation(self):
        self.assertEquals(str(self.user1.username), 'Ravi')
        self.assertEquals(self.userf1.type, 'faculty')

    def test_User_T_is_assigned_examdutyofficer_on_creation(self):
        self.assertEquals(str(self.user3.username), 'Rajesh')
        self.assertEquals(self.usere1.type, 'examdutyofficer')

    def test_User_T_is_assigned_admin_on_creation(self):
        self.assertEquals(str(self.user5.username), 'Mohan')
        self.assertEquals(self.usera3.type, 'admin')

    def test_User_T_is_assigned_with_user_already_assigned_to_another_User_T(self):
        with self.assertRaises(IntegrityError):
            User_T.objects.create(user=self.user4, type='faculty')

    def test_course_is_assigned_to_course_id_on_creation(self):
        self.assertEquals((self.course1.Course_ID), '15CSE101')
        self.assertEquals(self.course1.Course_name, 'maths')

    def test_course_is_assigned_for_an_existing_course_id(self):
        with self.assertRaises(IntegrityError):
            Course.objects.create(Course_ID='15CSE123', Course_name="maths")

    def test_room_is_allocated_for_existing_room_id(self):
        with self.assertRaises(IntegrityError):
            Room.objects.create(
                Room_ID='A-123', Block="Academic Block 2", capacity=120)

    def test_room_is_allocated_on_creation(self):
        self.assertEquals(self.room1.Room_ID, 'A-123')
        self.assertEquals(self.room1.Block, 'Academic Block-2')
        self.assertEquals(self.room1.capacity, 120)
        # ,Block = 'Academic Block 2', capacity = 120)

    def test_exam_is_alloted_for_a_valid_faculty_type(self):
        self.assertEquals(str(self.takesduty.faculty.user.username), 'Ravi')
        self.assertEquals(self.takesduty.faculty.type, 'faculty')
        self.assertEquals(self.takesduty.exam.exam.exam_name,
                          'periodical2-1st')

    def test_exam_is_alloted_for_a_invalid_faculty_type(self):
        t1 = TakeDuty.objects.create(
            faculty=self.userf1, exam=self.exam_allocation2)
        with self.assertRaises(ValidationError):
            t1.clean()

    def test_exam_is_conducted_by_a_valid_examdutyofficer_type(self):
        self.assertEquals(str(self.assignduty.edo.user.username), 'Rajesh')
        self.assertEquals(self.assignduty.edo.type, 'examdutyofficer')
        self.assertEquals(
            self.assignduty.exam.exam.exam_name, 'periodical2-1st')

    def test_exam_is_conducted_by_a_invalid_examdutyofficer_type(self):
        t3 = AssignDuty.objects.create(
            edo=self.usere1, exam=self.exam_allocation1)
        with self.assertRaises(ValidationError):
            t3.clean()

    def test_room_is_alloted_to_a_valid_faculty_type(self):
        # self.assertEquals(str(self.room_allocation1.user),'Kiran')
        self.assertEquals(self.room_allocation1.faculty.user.username, 'Kiran')
        self.assertEquals(self.room_allocation1.faculty.type, 'faculty')
        self.assertEquals(self.room_allocation1.room.Room_ID, 'A-123')

    def test_room_is_alloted_to_a_invalid_faculty_type(self):
        t2 = RoomAllocation.objects.create(
            faculty=self.userf2, room=self.room1)
        with self.assertRaises(ValidationError):
            t2.clean()

    def test_room_is_alloted_to_a_valid_exam_and_course(self):
        # self.assertEquals(str(self.room_allocation1.user),'Kiran')
        self.assertEquals(
            self.exam_allocation1.exam.exam_name, 'periodical2-1st')
        self.assertEquals(self.exam_allocation1.course.Course_ID, '15CSE123')
        self.assertEquals(self.exam_allocation1.room.Room_ID, 'A-123')

    def test_room_is_alloted_to_a_invalid_exam_and_course(self):
        t4 = ExamAllocation.objects.create(
            exam=self.exam1, course=self.course1, room=self.room1)
        with self.assertRaises(ValidationError):
            t4.clean()
