from django.db import models

# Create your models here.

class Bookmark(models.Model):
    name = models.CharField(max_length=80)
    url = models.URLField(max_length=200)
    description = models.TextField()
    def __str__(self):
        return self.name
