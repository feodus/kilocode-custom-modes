---
name: tailwind-css
description: Styling with Tailwind CSS. Use this skill when creating modern UI components, responsive interfaces, and design systems using Tailwind CSS.
---

# Tailwind CSS Guide

## Setup

```bash
# Vite + Tailwind
npm create vite@latest my-app -- --template react-ts
cd my-app
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

```javascript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          500: '#0ea5e9',
          600: '#0284c7',
          700: '#0369a1',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      spacing: {
        '128': '32rem',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}
```

```css
/* src/index.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  body {
    @apply antialiased text-gray-900 bg-gray-50;
  }
}

@layer components {
  .btn-primary {
    @apply px-4 py-2 bg-primary-600 text-white rounded-lg
           hover:bg-primary-700 focus:ring-2 focus:ring-primary-500
           transition-colors duration-200;
  }
  
  .card {
    @apply bg-white rounded-xl shadow-sm border border-gray-100 p-6;
  }
}
```

## Spacing

```html
<!-- Padding -->
<div class="p-4">       <!-- all sides -->
<div class="px-4">       <!-- horizontal -->
<div class="py-4">       <!-- vertical -->
<div class="pt-4 pr-4 pb-4 pl-4">  <!-- top, right, bottom, left -->
<div class="px-4 py-2">  <!-- x, y -->

<!-- Margin -->
<div class="m-4">        <!-- all -->
<div class="mx-auto">    <!-- horizontal auto -->
<div class="my-4">       <!-- vertical -->

<!-- Gap -->
<div class="flex gap-4">
<div class="grid grid-cols-3 gap-x-4 gap-y-8">
```

## Typography

```html
<!-- Text sizes -->
<p class="text-xs">     <!-- 0.75rem -->
<p class="text-sm">     <!-- 0.875rem -->
<p class="text-base">  <!-- 1rem -->
<p class="text-lg">    <!-- 1.125rem -->
<p class="text-xl">    <!-- 1.25rem -->
<p class="text-2xl">   <!-- 1.5rem -->
<p class="text-3xl">   <!-- 1.875rem -->
<p class="text-4xl">   <!-- 2.25rem -->

<!-- Font weight -->
<p class="font-light">      <!-- 300 -->
<p class="font-normal">     <!-- 400 -->
<p class="font-medium">    <!-- 500 -->
<p class="font-semibold">  <!-- 600 -->
<p class="font-bold">      <!-- 700 -->

<!-- Text colors -->
<p class="text-gray-50">    to text-gray-950
<p class="text-red-500">
<p class="text-primary-600">

<!-- Styling -->
<p class="italic">         <!-- italic -->
<p class="underline">     <!-- underline -->
<p class="line-through">  <!-- strikethrough -->
<p class="uppercase">     <!-- uppercase -->
<p class="capitalize">    <!-- capitalize -->
<p class="tracking-wide"> <!-- letter spacing -->
```

## Colors

```html
<!-- Background color -->
<div class="bg-white bg-gray-50 bg-primary-500">

<!-- Opacity -->
<div class="bg-black/50">        <!-- 50% opacity -->
<div class="bg-white/75">

<!-- Gradient -->
<div class="bg-gradient-to-r from-primary-500 to-primary-700">
<div class="bg-gradient-to-br from-pink-500 via-red-500 to-yellow-500">

<!-- Text opacity -->
<p class="text-gray-500/80">
```

## Layout

```html
<!-- Display -->
<div class="block">
<div class="inline">
<div class="inline-block">
<div class="hidden">

<!-- Flexbox -->
<div class="flex">
<div class="flex flex-row">          <!-- row by default -->
<div class="flex flex-col">
<div class="flex flex-wrap">

<!-- Flex alignment -->
<div class="flex items-center">       <!-- vertical -->
<div class="flex justify-center">      <!-- horizontal -->
<div class="flex justify-between">
<div class="flex justify-around">
<div class="flex items-stretch">

<!-- Gap -->
<div class="flex gap-4">
<div class="flex gap-x-4 gap-y-8">

<!-- Grid -->
<div class="grid grid-cols-2">
<div class="grid grid-cols-3">
<div class="grid grid-cols-4">
<div class="grid grid-cols-6">

<!-- Grid gap -->
<div class="grid gap-4">
<div class="grid gap-x-8 gap-y-4">
```

## Responsive

```html
<!-- Mobile first -->
<!-- sm: 640px -->
<!-- md: 768px -->
<!-- lg: 1024px -->
<!-- xl: 1280px -->
<!-- 2xl: 1536px -->

<!-- Only on mobile -->
<div class="block md:hidden">

<!-- Hidden on mobile, visible on desktop -->
<div class="hidden md:block">

<!-- Responsive text -->
<p class="text-sm md:text-base lg:text-lg">

<!-- Responsive flex -->
<div class="flex flex-col md:flex-row">
```

## Components

### Button

```tsx
type ButtonProps = {
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  loading?: boolean
  children: React.ReactNode
} & React.ButtonHTMLAttributes<HTMLButtonElement>

export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  className = '',
  disabled,
  children,
  ...props
}: ButtonProps) {
  const variants = {
    primary: 'bg-primary-600 text-white hover:bg-primary-700',
    secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200',
    danger: 'bg-red-600 text-white hover:bg-red-700',
    ghost: 'bg-transparent hover:bg-gray-100',
  }
  
  const sizes = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2',
    lg: 'px-6 py-3 text-lg',
  }
  
  return (
    <button
      className={`
        inline-flex items-center justify-center font-medium rounded-lg
        focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2
        disabled:opacity-50 disabled:cursor-not-allowed
        transition-colors duration-200
        ${variants[variant]}
        ${sizes[size]}
        ${className}
      `}
      disabled={disabled || loading}
      {...props}
    >
      {loading && (
        <svg className="animate-spin -ml-1 mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
        </svg>
      )}
      {children}
    </button>
  )
}
```

### Input

```tsx
type InputProps = {
  label?: string
  error?: string
  helperText?: string
} & React.InputHTMLAttributes<HTMLInputElement>

export function Input({
  label,
  error,
  helperText,
  className = '',
  id,
  ...props
}: InputProps) {
  const inputId = id || props.name
  
  return (
    <div className="w-full">
      {label && (
        <label htmlFor={inputId} className="block text-sm font-medium text-gray-700 mb-1">
          {label}
        </label>
      )}
      <input
        id={inputId}
        className={`
          block w-full rounded-lg border px-4 py-2
          focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500
          transition-colors duration-200
          ${error
            ? 'border-red-500 focus:ring-red-500 focus:border-red-500'
            : 'border-gray-300'
          }
          ${className}
        `}
        {...props}
      />
      {error && <p className="mt-1 text-sm text-red-600">{error}</p>}
      {helperText && !error && <p className="mt-1 text-sm text-gray-500">{helperText}</p>}
    </div>
  )
}
```

### Card

```tsx
export function Card({
  children,
  className = '',
  hover = false,
}: {
  children: React.ReactNode
  className?: string
  hover?: boolean
}) {
  return (
    <div
      className={`
        bg-white rounded-xl border border-gray-100 p-6
        ${hover ? 'hover:shadow-lg hover:border-gray-200 transition-all duration-200' : 'shadow-sm'}
        ${className}
      `}
    >
      {children}
    </div>
  )
}

export function CardHeader({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return <div className={`mb-4 ${className}`}>{children}</div>
}

export function CardTitle({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return <h3 className={`text-lg font-semibold text-gray-900 ${className}`}>{children}</h3>
}

export function CardContent({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return <div className={className}>{children}</div>
}
```

### Badge

```tsx
type BadgeProps = {
  variant?: 'default' | 'success' | 'warning' | 'danger' | 'info'
  children: React.ReactNode
}

export function Badge({ variant = 'default', children }: BadgeProps) {
  const variants = {
    default: 'bg-gray-100 text-gray-800',
    success: 'bg-green-100 text-green-800',
    warning: 'bg-yellow-100 text-yellow-800',
    danger: 'bg-red-100 text-red-800',
    info: 'bg-blue-100 text-blue-800',
  }
  
  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${variants[variant]}`}>
      {children}
    </span>
  )
}
```

## Animations

```html
<!-- Transition -->
<div class="transition-all duration-300">

<!-- Hover effects -->
<button className="hover:bg-blue-700 hover:scale-105">

<!-- Animations -->
<div class="animate-spin">
<div class="animate-pulse">
<div class="animate-bounce">

<!-- Custom animation in tailwind.config.js -->
<div class="animate-fade-in">
```

```javascript
// tailwind.config.js
theme: {
  extend: {
    keyframes: {
      'fade-in': {
        '0%': { opacity: '0' },
        '100%': { opacity: '1' },
      },
      'slide-up': {
        '0%': { transform: 'translateY(10px)', opacity: '0' },
        '100%': { transform: 'translateY(0)', opacity: '1' },
      },
    },
    animation: {
      'fade-in': 'fade-in 0.3s ease-out',
      'slide-up': 'slide-up 0.3s ease-out',
    },
  },
}
```

## Dark Mode

```html
<!-- tailwind.config.js -->
<div className="dark">

<!-- Dark theme -->
<div class="bg-white dark:bg-gray-900">
<div class="text-gray-900 dark:text-white">
<div class="dark:hidden">

<!-- Dark class by default -->
<div class="dark:bg-gray-800">
```

## Best Practices

1. **Use utility classes** - avoid custom CSS
2. **Componentize** - repeated patterns into components
3. **Configure** - extend theme for design system
4. **Responsive** - mobile-first approach
5. **Dark mode** - support from the start
6. **Spacing** - use consistent values
7. **Colors** - limited palette
8. **Animations** - smooth transitions
9. **Forms** - @tailwindcss/forms plugin
10. **Prefix** - avoid conflicts with `--tw-`
