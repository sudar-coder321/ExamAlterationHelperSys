
from django.contrib.auth.models import User, Group
from .models import User_T, Room, RoomAllocation, Exam, TakeDuty, AssignDuty, Course, ExamAllocation, Notification, Grievances, FreqQuestions, Answers,  QuesAnsRelation
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin, AdminPasswordChangeForm
from django.contrib import admin

admin.site.site_header = 'FacAssist'
admin.site.site_title = 'FacAssist'
admin.site.index_title = "ADMIN ACCOUNT"


class UserInline(admin.StackedInline):
    model = User_T
    extra = 1


# class CourseInline(admin.StackedInline):
#     model = Course
#     extra = 1


# class RoomInline(admin.StackedInline):
#     model = Room
#     extra = 1


# class ExamInline(admin.StackedInline):
#     model = Exam
#     extra = 1


# class ExamAllocationInline(admin.TabularInline):
#     model = ExamAllocation
#     extra = 1

# class RoomAllocationInline(admin.StackedInline):
#     model = RoomAllocation
#     extra = 1


# class AssignDutyInline(admin.TabularInline):
#     model = AssignDuty
#     extra = 1


# class TakeDutyInline(admin.TabularInline):
#     model = TakeDuty
#     extra = 1


class UserAdmin(DjangoUserAdmin):
    list_display = ('username', 'email', 'first_name',
                    'last_name', 'is_superuser')
    inlines = (UserInline, )

    def save_model(self, request, obj, form, change):

        obj.user = request.user
        super().save_model(request, obj, form, change)
        try:
            a = User_T.objects.filter(user=obj)
            Notification(
                user=a[0], notification=a[0].username+"details have been updated.").save()
        except:
            pass


class RoomAllocationAdmin(admin.ModelAdmin):
    model = RoomAllocation
    extra = 0


class NotificationAdmin(admin.ModelAdmin):
    model = Notification


class RoomAdmin(admin.ModelAdmin):
    model = Room
    extra = 0


class ExamAdmin(admin.ModelAdmin):
    model = Exam
    extra = 0


class TakeDutyAdmin(admin.ModelAdmin):
    model = TakeDuty
    extra = 0


class AssignDutyAdmin(admin.ModelAdmin):
    model = AssignDuty
    extra = 0


class FreqQuestionsAdmin(admin.ModelAdmin):
    model = FreqQuestions
    extra = 0


class ExamAllocationAdmin(admin.ModelAdmin):
    model = ExamAllocation
    extra = 0


class AnswersAdmin(admin.ModelAdmin):
    model = Answers
    extra = 0


class QuesAnsRelationAdmin(admin.ModelAdmin):
    model = QuesAnsRelation
    extra = 0


class CourseAdmin(admin.ModelAdmin):
    model = Course
    extra = 0


class GrievancesAdmin(admin.ModelAdmin):
    model = Grievances
    extra = 0
    # class ExamAdmin(admin.ModelAdmin):
    #     model = Exam
    #     extra = 1

    # class ExamAdmin(admin.ModelAdmin):
    #     model = Exam
    #     extra = 1

    # class ExamAdmin(admin.ModelAdmin):
    #     model = Exam
    #     extra = 1


admin.site.unregister(Group)
admin.site.unregister(User)
admin.site.register(Grievances)
admin.site.register(User, UserAdmin)
admin.site.register(Room)
admin.site.register(Exam)
admin.site.register(RoomAllocation)
admin.site.register(TakeDuty)
admin.site.register(AssignDuty)
admin.site.register(ExamAllocation)
admin.site.register(Course)
admin.site.register(Notification)
admin.site.register(FreqQuestions)
admin.site.register(Answers)
admin.site.register(QuesAnsRelation)
# admin.site.register()
