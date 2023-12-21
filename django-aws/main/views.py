from django.shortcuts import get_object_or_404, render, redirect
from .forms import CreateUserForm, LoginForm, UpdateUserForm, UpdateProfileForm
from .models import Profile
from django.contrib.auth.models import auth 
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User 
from django.contrib.auth.decorators import login_required


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


@login_required(login_url="my-login")
def dashboard(request):
    profile_pic = Profile.objects.get(user=request.user)
    context = {"profile_pic": profile_pic}
    return render(request, "main/dashboard.html", context=context)


@login_required(login_url="my-login")
def profile_management(request):
    user_form = UpdateUserForm(instance=request.user)
    
    profile = Profile.objects.get(user=request.user)
    
    profile_form = UpdateProfileForm(instance=profile)
    
    if request.method == "POST":
        user_form = UpdateUserForm(request.POST, instance=request.user)
        
        profile_form = UpdateProfileForm(request.POST, request.FILES, instance=profile)
        
        if user_form.is_valid():
            user_form.save()
            return redirect("dashboard")
        
        if profile_form.is_valid():
            profile_form.save()
            return redirect("dashboard")
        
    context = {"user_form": user_form, "profile_form":profile_form}
    return render(request, "main/profile-management.html", context=context)


@login_required(login_url="my-login")
def delete_account(request):
    if request.method == "POST":
        deleted_user = User.objects.get(username=request.user)
        deleted_user.delete()
        
        return redirect("home")

    return render(request, "main/delete-account.html")

def profile_single(request, profile):
    profile = get_object_or_404(Profile, user=profile.user )
    return render(request, "main/single-profile.html", {"profile": profile})
