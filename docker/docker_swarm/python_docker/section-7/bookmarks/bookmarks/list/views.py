from django.shortcuts import render

# Create your views here.
from .models import Bookmark
from django.views.generic import ListView, DetailView

class BookmarksList(ListView):
    model = Bookmark

class BookmarkDetail(DetailView):
    model = Bookmark
    queryset = Bookmark.objects.all()
