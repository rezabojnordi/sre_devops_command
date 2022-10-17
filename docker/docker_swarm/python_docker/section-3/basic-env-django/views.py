from django.http import HttpResponse
def index(request):
    return HttpResponse("Hello World! I run in a Python Runtime
Container! ")
