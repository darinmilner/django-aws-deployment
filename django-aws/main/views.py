from django.shortcuts import render, redirect
from .forms import CreateUserForm, LoginForm
from .models import Profile
from django.contrib.auth.models import auth 
from django.contrib.auth import authenticate, login


def index(request):
    return render(request, "main/index.html")


def register(request):
    form = CreateUserForm()
    if request.method == "POST":
        form = CreateUserForm(request.POST)
        
        if form.is_valid():
            current_user = form.save(commit=False)
            form.save()
            
            profile = Profile.objects.create(user=current_user)
            
            return redirect("my-login")
            
    context = {"form": form}        
    return render(request, "main/register.html", context=context)


def my_login(request):
    form = LoginForm()
    if request.method == "POST":
        form = LoginForm(request, data=request.POST)
        if form.is_valid():
            username = request.POST.get("username")
            password = request.POST.get("password")
            user = authenticate(request, username=username, password=password)
            if user is not None:
                auth.login(request, user)
                return redirect("dashboard")
            
    context = {"form": form}
    return render(request, "main/my-login.html", context=context)


def user_logout(request):
    auth.logout(request)
    return redirect("home") 


def dashboard(request):
    return render(request, "main/dashboard.html")


def profile_management(request):
    return render(request, "main/profile-management.html")

