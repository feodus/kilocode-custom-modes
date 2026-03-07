---
name: django-development
description: Full-featured Django web application development. Use this skill when creating Django projects, models, views, forms, admin panel, and REST API with Django REST Framework.
---

# Django Development Guide

## Django Basics

Django is a high-level Python web framework following the "batteries included" principle.

### Installation and Project Setup

```bash
# Install Django
pip install django djangorestframework

# Create new project
django-admin startproject myproject

# Create app
cd myproject
python manage.py startapp myapp
```

## Django Architecture

### Recommended Project Structure

```
myproject/
├── myproject/              # Project configuration
│   ├── __init__.py
│   ├── settings.py         # Settings
│   ├── urls.py             # URL routing
│   ├── wsgi.py            # WSGI entry point
│   └── asgi.py            # ASGI entry point
├── apps/                   # Applications
│   ├── users/             # Users app
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── serializers.py
│   │   └── admin.py
│   └── products/         # Products app
├── templates/             # HTML templates
├── static/                # Static files
├── media/                 # Uploaded files
├── requirements.txt
├── manage.py
└── .env
```

## Models

### Basic Model Examples

```python
# models.py
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone


class User(AbstractUser):
    """Custom user model"""
    email = models.EmailField(unique=True)
    bio = models.TextField(blank=True)
    avatar = models.ImageField(upload_to='avatars/', blank=True)
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['email']),
            models.Index(fields=['-created_at']),
        ]

    def __str__(self):
        return self.username


class Category(models.Model):
    """Product category"""
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    description = models.TextField(blank=True)
    parent = models.ForeignKey(
        'self',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='children'
    )

    class Meta:
        verbose_name_plural = 'categories'
        ordering = ['name']

    def __str__(self):
        return self.name


class Product(models.Model):
    """Product model"""
    name = models.CharField(max_length=200)
    slug = models.SlugField(max_length=200)
    category = models.ForeignKey(
        Category,
        on_delete=models.SET_NULL,
        null=True,
        related_name='products'
    )
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.PositiveIntegerField(default=0)
    image = models.ImageField(upload_to='products/', blank=True)
    is_available = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['slug']),
            models.Index(fields=['-created_at']),
            models.Index(fields=['price']),
        ]

    def __str__(self):
        return self.name
```

### Advanced Models

```python
# Soft Delete Pattern
class SoftDeleteManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().filter(is_deleted=False)


class SoftDeleteModel(models.Model):
    """Model with soft delete"""
    is_deleted = models.BooleanField(default=False)
    deleted_at = models.DateTimeField(null=True, blank=True)

    objects = SoftDeleteManager()
    all_objects = models.Manager()

    class Meta:
        abstract = True

    def delete(self, using=None, keep_parents=False):
        self.is_deleted = True
        self.deleted_at = timezone.now()
        self.save()


class TimestampedModel(models.Model):
    """Model with timestamps"""
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


# UUID Pattern instead of ID
import uuid

class UUIDModel(models.Model):
    """Model with UUID instead of ID"""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    class Meta:
        abstract = True
```

## Views and URLs

### Function-Based Views

```python
# views.py
from django.shortcuts import render, get_object_or_404, redirect
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator
from .models import Product, Category
from .forms import ProductForm


def product_list(request):
    """Product list with pagination"""
    products = Product.objects.filter(is_available=True)
    
    # Pagination
    paginator = Paginator(products, 12)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    # Filtering
    category_id = request.GET.get('category')
    if category_id:
        products = products.filter(category_id=category_id)
    
    return render(request, 'products/list.html', {
        'page_obj': page_obj,
        'categories': Category.objects.all()
    })


def product_detail(request, slug):
    """Product detail page"""
    product = get_object_or_404(Product, slug=slug, is_available=True)
    return render(request, 'products/detail.html', {'product': product})


@login_required
def product_create(request):
    """Create product"""
    if request.method == 'POST':
        form = ProductForm(request.POST, request.FILES)
        if form.is_valid():
            product = form.save(commit=False)
            product.created_by = request.user
            product.save()
            return redirect('product_detail', slug=product.slug)
    else:
        form = ProductForm()
    return render(request, 'products/form.html', {'form': form})


# API View for JSON
@require_http_methods(["GET"])
def product_api_list(request):
    products = Product.objects.filter(is_available=True).values(
        'id', 'name', 'slug', 'price', 'image'
    )
    return JsonResponse({'products': list(products)})
```

### Class-Based Views

```python
from django.views.generic import (
    ListView, DetailView, CreateView, UpdateView, DeleteView
)
from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse_lazy
from .models import Product
from .forms import ProductForm


class ProductListView(ListView):
    """Product list"""
    model = Product
    template_name = 'products/list.html'
    context_object_name = 'products'
    paginate_by = 12

    def get_queryset(self):
        queryset = Product.objects.filter(is_available=True)
        
        # Filtering by category
        category = self.request.GET.get('category')
        if category:
            queryset = queryset.filter(category_id=category)
        
        # Search
        search = self.request.GET.get('search')
        if search:
            queryset = queryset.filter(name__icontains=search)
        
        return queryset

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['categories'] = Category.objects.all()
        return context


class ProductDetailView(DetailView):
    """Product detail page"""
    model = Product
    template_name = 'products/detail.html'
    context_object_name = 'product'
    query_pk_and_slug = True


class ProductCreateView(LoginRequiredMixin, CreateView):
    """Create product"""
    model = Product
    form_class = ProductForm
    template_name = 'products/form.html'
    success_url = reverse_lazy('product_list')

    def form_valid(self, form):
        form.instance.created_by = self.request.user
        return super().form_valid(form)


class ProductUpdateView(LoginRequiredMixin, UpdateView):
    """Edit product"""
    model = Product
    form_class = ProductForm
    template_name = 'products/form.html'

    def get_queryset(self):
        return Product.objects.filter(created_by=self.request.user)


class ProductDeleteView(LoginRequiredMixin, DeleteView):
    """Delete product"""
    model = Product
    template_name = 'products/confirm_delete.html'
    success_url = reverse_lazy('product_list')

    def get_queryset(self):
        return Product.objects.filter(created_by=self.request.user)
```

### URL Routing

```python
# myapp/urls.py
from django.urls import path
from . import views

app_name = 'products'

urlpatterns = [
    path('', views.ProductListView.as_view(), name='product_list'),
    path('<slug:slug>/', views.ProductDetailView.as_view(), name='product_detail'),
    path('create/', views.ProductCreateView.as_view(), name='product_create'),
    path('<slug:slug>/edit/', views.ProductUpdateView.as_view(), name='product_update'),
    path('<slug:slug>/delete/', views.ProductDeleteView.as_view(), name='product_delete'),
    path('api/', views.product_api_list, name='product_api_list'),
]
```

```python
# project/urls.py
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('products/', include('products.urls', namespace='products')),
    path('api/v1/products/', include('products.api_urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

## Forms

```python
# forms.py
from django import forms
from django.core.exceptions import ValidationError
from .models import Product


class ProductForm(forms.ModelForm):
    """Product form"""
    
    class Meta:
        model = Product
        fields = ['name', 'slug', 'category', 'description', 'price', 'stock', 'image']
        widgets = {
            'description': forms.Textarea(attrs={'rows': 4}),
            'image': forms.FileInput(attrs={'accept': 'image/*'}),
        }
    
    def clean_slug(self):
        slug = self.cleaned_data.get('slug')
        if not slug:
            # Generate slug from name
            from django.utils.text import slugify
            slug = slugify(self.cleaned_data.get('name', ''))
        
        # Check uniqueness
        queryset = Product.objects.filter(slug=slug)
        if self.instance.pk:
            queryset = queryset.exclude(pk=self.instance.pk)
        
        if queryset.exists():
            raise ValidationError('URL slug already exists')
        
        return slug
    
    def clean_price(self):
        price = self.cleaned_data.get('price')
        if price and price <= 0:
            raise ValidationError('Price must be greater than zero')
        return price


class ContactForm(forms.Form):
    """Contact form"""
    name = forms.CharField(max_length=100, min_length=2)
    email = forms.EmailField()
    subject = forms.CharField(max_length=200)
    message = forms.CharField(widget=forms.Textarea)
    
    def clean_message(self):
        message = self.cleaned_data.get('message')
        if len(message) < 10:
            raise ValidationError('Message is too short')
        return message
```

## Django REST Framework

### Serializers

```python
# serializers.py
from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Product, Category

User = get_user_model()


class CategorySerializer(serializers.ModelSerializer):
    """Category serializer"""
    products_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Category
        fields = ['id', 'name', 'slug', 'description', 'parent', 'products_count']
    
    def get_products_count(self, obj):
        return obj.products.count()


class ProductSerializer(serializers.ModelSerializer):
    """Product serializer"""
    category_name = serializers.CharField(source='category.name', read_only=True)
    category_slug = serializers.CharField(source='category.slug', read_only=True)
    
    class Meta:
        model = Product
        fields = [
            'id', 'name', 'slug', 'description', 'price', 'stock',
            'image', 'is_available', 'category', 'category_name',
            'category_slug', 'created_at', 'updated_at'
        ]
        read_only_fields = ['created_at', 'updated_at']
    
    def validate_price(self, value):
        if value <= 0:
            raise serializers.ValidationError('Price must be positive')
        return value


class UserSerializer(serializers.ModelSerializer):
    """User serializer"""
    
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'bio', 'avatar']
        read_only_fields = ['id']


class UserRegistrationSerializer(serializers.ModelSerializer):
    """Registration serializer"""
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'password_confirm', 'first_name', 'last_name']
    
    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError('Passwords do not match')
        return data
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(**validated_data)
        return user
```

### API Views

```python
# views.py (API)
from rest_framework import viewsets, status, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django_filters.rest_framework import DjangoFilterBackend
from .models import Product, Category
from .serializers import ProductSerializer, CategorySerializer


class ProductViewSet(viewsets.ModelViewSet):
    """ViewSet for products"""
    queryset = Product.objects.filter(is_available=True)
    serializer_class = ProductSerializer
    permission_classes = [AllowAny]
    
    # Filtering and search
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['category', 'is_available', 'price']
    search_fields = ['name', 'description']
    ordering_fields = ['price', 'created_at', 'name']
    ordering = ['-created_at']
    
    @action(detail=True, permission_classes=[IsAuthenticated])
    def like(self, request, pk=None):
        """Like product"""
        product = self.get_object()
        if request.user in product.likes.all():
            product.likes.remove(request.user)
            return Response({'status': 'unliked'})
        product.likes.add(request.user)
        return Response({'status': 'liked'})
    
    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Featured products"""
        products = self.queryset.filter(is_available=True)[:8]
        serializer = self.get_serializer(products, many=True)
        return Response(serializer.data)
```

### URL for DRF

```python
# urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet, CategoryViewSet

router = DefaultRouter()
router.register(r'products', ProductViewSet)
router.register(r'categories', CategoryViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
```

## Admin

```python
# admin.py
from django.contrib import admin
from django.utils.html import format_html
from .models import Product, Category, User


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'parent', 'products_count']
    list_filter = ['parent']
    search_fields = ['name', 'slug']
    prepopulated_fields = {'slug': ('name',)}
    
    def products_count(self, obj):
        return obj.products.count()
    products_count.short_description = 'Products'


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'price', 'stock', 'is_available', 'thumbnail', 'created_at']
    list_filter = ['is_available', 'category', 'created_at']
    search_fields = ['name', 'description']
    prepopulated_fields = {'slug': ('name',)}
    list_editable = ['price', 'stock', 'is_available']
    date_hierarchy = 'created_at'
    
    fieldsets = (
        ('Basic Info', {
            'fields': ('name', 'slug', 'category', 'description')
        }),
        ('Pricing & Stock', {
            'fields': ('price', 'stock')
        }),
        ('Media', {
            'fields': ('image',)
        }),
        ('Status', {
            'fields': ('is_available',)
        }),
    )
    
    def thumbnail(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" style="width: 50px; height: auto;">',
                obj.image.url
            )
        return '-'
    thumbnail.short_description = 'Image'
```

## Middleware

```python
# middleware.py
from django.utils.deprecation import MiddlewareMixin
from django.http import JsonResponse
import logging

logger = logging.getLogger(__name__)


class RequestLoggingMiddleware(MiddlewareMixin):
    """Logging all requests"""
    
    def process_request(self, request):
        logger.info(f'{request.method} {request.path}')
        return None
    
    def process_response(self, request, response):
        logger.info(f'{request.path} - {response.status_code}')
        return response


class RateLimitMiddleware(MiddlewareMixin):
    """Simple rate limiting"""
    
    def process_request(self, request):
        ip = request.META.get('REMOTE_ADDR')
        # Rate limiting logic can be added here
        return None


class CORSMiddleware(MiddlewareMixin):
    """CORS for API"""
    
    def process_response(self, request, response):
        response['Access-Control-Allow-Origin'] = '*'
        response['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
        response['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
        return response
```

## Django Testing

```python
# tests/test_models.py
from django.test import TestCase
from django.contrib.auth import get_user_model
from products.models import Category, Product

User = get_user_model()


class CategoryModelTest(TestCase):
    def test_category_creation(self):
        category = Category.objects.create(
            name='Electronics',
            slug='electronics'
        )
        self.assertEqual(str(category), 'Electronics')
        self.assertEqual(category.products.count(), 0)


class ProductModelTest(TestCase):
    def setUp(self):
        self.category = Category.objects.create(
            name='Electronics',
            slug='electronics'
        )
    
    def test_product_creation(self):
        product = Product.objects.create(
            name='Laptop',
            slug='laptop',
            category=self.category,
            price=999.99,
            stock=10
        )
        self.assertEqual(str(product), 'Laptop')
        self.assertEqual(product.price, 999.99)
        self.assertTrue(product.is_available)
```

```python
# tests/test_views.py
from django.test import TestCase, Client
from django.urls import reverse
from products.models import Category, Product
import json


class ProductListViewTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.category = Category.objects.create(name='Test', slug='test')
        self.product = Product.objects.create(
            name='Test Product',
            slug='test-product',
            category=self.category,
            price=100,
            stock=5
        )
    
    def test_product_list_view(self):
        response = self.client.get(reverse('products:product_list'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Test Product')
    
    def test_product_api_list(self):
        response = self.client.get('/api/v1/products/')
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(len(data['results']), 1)
```

## Docker for Django

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy code
COPY . .

# Migrations
RUN python manage.py migrate --noinput
RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DEBUG=0
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    volumes:
      - ./media:/app/media

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  postgres_data:
```

## Best Practices

1. **Use CBV** - Class-Based Views for code reusability
2. **Separate business logic** - use services or managers
3. **Always validate** - both at form and serializer level
4. **Use migrations** - don't edit DB directly
5. **Cache** - use Redis for frequently requested data
6. **Log** - for debugging and monitoring
7. **Test** - cover code with tests
8. **Use signals** - for automated actions
9. **Separate settings** - for dev/staging/prod
10. **Use environment variables** - don't hardcode secrets

## Commands

```bash
# Migrations
python manage.py makemigrations
python manage.py migrate

# Superuser
python manage.py createsuperuser

# Run
python manage.py runserver

# Tests
python manage.py test

# Shell
python manage.py shell

# Collectstatic
python manage.py collectstatic
```
