# Generated by Django 4.1.7 on 2023-04-10 08:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("smarthome", "0002_usertable_alter_hometable_user_id"),
    ]

    operations = [
        migrations.CreateModel(
            name="HomeInfoTable",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("temp", models.CharField(max_length=255)),
                ("humudity", models.CharField(max_length=255)),
                ("desiredTemp", models.CharField(max_length=255)),
                ("home_name", models.CharField(max_length=255)),
                ("door_status", models.BooleanField()),
                ("fan_status", models.BooleanField()),
                ("light_status", models.BooleanField()),
            ],
        ),
        migrations.CreateModel(
            name="UserInfoTable",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("username", models.CharField(max_length=255)),
                ("password", models.CharField(max_length=255)),
                ("card_number", models.CharField(max_length=255)),
                ("active_status", models.BooleanField()),
                ("home_name", models.CharField(max_length=255)),
                ("approve_status", models.BooleanField()),
            ],
        ),
        migrations.DeleteModel(
            name="HomeTable",
        ),
        migrations.DeleteModel(
            name="UserTable",
        ),
    ]
