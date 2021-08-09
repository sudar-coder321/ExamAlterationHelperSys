# Generated by Django 3.2.4 on 2021-06-12 05:47

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('examaltersys', '0003_answers_freqquestions_quesansrelation'),
    ]

    operations = [
        migrations.CreateModel(
            name='Grievances',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('grieve_text', models.CharField(max_length=255)),
                ('user', models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, to='examaltersys.user_t')),
            ],
            options={
                'verbose_name': 'GrievancesObject',
                'verbose_name_plural': 'GrievancesObjects',
            },
        ),
    ]
