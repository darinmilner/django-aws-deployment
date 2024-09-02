from django.shortcuts import render
from django.http import HttpResponse

def hello(request, resource=None):
    return render(request, "index.html", {"name": resource or "AWS"})

def test_django(request):
    return HttpResponse("I am a Django Lambda!")
