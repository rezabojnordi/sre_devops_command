from django.urls import path
from . import views

urlpatterns = [
#    path('', views.index, name='index'),
    path('', views.BookmarksList.as_view(), name='index'),
    path('<int:pk>/', views.BookmarkDetail.as_view(), name='detail'),
]
