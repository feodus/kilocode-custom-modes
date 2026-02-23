---
name: react-nextjs-development
description: Developing modern web applications with React and Next.js 14+ App Router. Use this skill when creating SSR/SSG applications, API routes, Server Components, and database integrations.
---

# React and Next.js Development Guide

## Project Setup

### Creating a Project

```bash
# Create Next.js project
npx create-next-app@latest my-app --typescript --tailwind --eslint

# With TypeScript + App Router (default in Next.js 14+)
npx create-next-app@latest my-app --ts --tailwind --app

# Add to existing project
npm install next react react-dom
npm install -D typescript @types/react @types/node
```

## Next.js 14+ Project Structure

```
my-app/
├── src/
│   ├── app/                    # App Router (Next.js 13+)
│   │   ├── (marketing)/        # Route groups
│   │   │   ├── page.tsx
│   │   │   └── layout.tsx
│   │   ├── (dashboard)/
│   │   │   ├── dashboard/
│   │   │   │   └── page.tsx
│   │   │   └── layout.tsx
│   │   ├── api/               # API Routes
│   │   │   ├── users/
│   │   │   │   └── route.ts
│   │   │   └── route.ts
│   │   ├── layout.tsx         # Root layout
│   │   ├── page.tsx           # Home page
│   │   ├── globals.css
│   │   └── not-found.tsx
│   ├── components/            # React components
│   │   ├── ui/               # Basic UI components
│   │   ├── forms/            # Forms
│   │   └── features/         # Feature components
│   ├── lib/                  # Utilities
│   │   ├── db.ts            # Database client
│   │   ├── auth.ts          # Auth logic
│   │   └── utils.ts
│   ├── hooks/                # Custom hooks
│   ├── types/                # TypeScript types
│   └── styles/              # Styles
├── public/                   # Static files
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```

## App Router

### Layouts

```tsx
// src/app/layout.tsx - Root Layout
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { Providers } from '@/components/providers'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'My App',
  description: 'Description here',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ru">
      <body className={inter.className}>
        <Providers>
          <header>Header</header>
          <main>{children}</main>
          <footer>Footer</footer>
        </Providers>
      </body>
    </html>
  )
}
```

```tsx
// src/app/(dashboard)/layout.tsx - Route Group Layout
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="flex">
      <aside className="w-64">Sidebar</aside>
      <div className="flex-1">{children}</div>
    </div>
  )
}
```

### Pages

```tsx
// src/app/page.tsx - Server Component (default)
import Link from 'next/link'
import { getProducts } from '@/lib/db'

export default async function HomePage() {
  const products = await getProducts()

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-3xl font-bold mb-4">Products</h1>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {products.map((product) => (
          <Link 
            key={product.id} 
            href={`/products/${product.slug}`}
            className="border rounded p-4 hover:shadow-lg"
          >
            <h2 className="text-xl font-semibold">{product.name}</h2>
            <p className="text-gray-600">${product.price}</p>
          </Link>
        ))}
      </div>
    </div>
  )
}
```

### Server Components vs Client Components

```tsx
// src/components/Counter.tsx - Client Component
'use client'

import { useState } from 'react'

export function Counter() {
  const [count, setCount] = useState(0)

  return (
    <div>
      <p>Count: {count}</p>
      <button 
        onClick={() => setCount(count + 1)}
        className="btn btn-primary"
      >
        Increment
      </button>
    </div>
  )
}
```

```tsx
// src/app/page.tsx - Server Component
import { Counter } from '@/components/Counter'

export default function Page() {
  return (
    <div>
      <h1>Server Page</h1>
      {/* Client Component in Server Component */}
      <Counter />
    </div>
  )
}
```

### Route Parameters

```tsx
// src/app/products/[slug]/page.tsx - Dynamic Route
import { notFound } from 'next/navigation'
import { getProductBySlug } from '@/lib/db'

interface Props {
  params: { slug: string }
}

export default async function ProductPage({ params }: Props) {
  const product = await getProductBySlug(params.slug)
  
  if (!product) {
    notFound()
  }

  return (
    <div>
      <h1>{product.name}</h1>
      <p>{product.description}</p>
    </div>
  )
}
```

```tsx
// src/app/products/[category]/[slug]/page.tsx
interface Props {
  params: { 
    category: string 
    slug: string 
  }
}

export default function ProductPage({ params }: Props) {
  const { category, slug } = params
  // ...
}
```

### Search and Pagination

```tsx
// src/app/products/page.tsx
import { Suspense } from 'react'
import { ProductList } from '@/components/ProductList'
import { ProductListSkeleton } from '@/components/skeletons'

interface Props {
  searchParams: { 
    q?: string 
    page?: string 
    sort?: string 
  }
}

export default async function ProductsPage({ searchParams }: Props) {
  const query = searchParams.q || ''
  const page = Number(searchParams.page) || 1
  const sort = searchParams.sort || 'newest'

  return (
    <div>
      <form action="/products" method="GET">
        <input 
          name="q" 
          defaultValue={query}
          placeholder="Search products..."
        />
        <select name="sort" defaultValue={sort}>
          <option value="newest">Newest</option>
          <option value="price-asc">Price: Low to High</option>
          <option value="price-desc">Price: High to Low</option>
        </select>
        <button type="submit">Search</button>
      </form>

      <Suspense fallback={<ProductListSkeleton />}>
        <ProductList query={query} page={page} sort={sort} />
      </Suspense>
    </div>
  )
}
```

## Data Fetching

### Server Actions

```tsx
// src/app/actions.ts
'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { z } from 'zod'

const schema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
})

export async function createUser(formData: FormData) {
  const validatedFields = schema.safeParse({
    name: formData.get('name'),
    email: formData.get('email'),
  })

  if (!validatedFields.success) {
    return { errors: validatedFields.error.flatten().fieldErrors }
  }

  // Save to DB
  await createUserInDb(validatedFields.data)

  revalidatePath('/users')
  redirect('/users')
}
```

```tsx
// src/components/UserForm.tsx - Client Component
'use client'

import { createUser } from '@/app/actions'

export function UserForm() {
  return (
    <form action={createUser}>
      <input name="name" type="text" />
      <input name="email" type="email" />
      <button type="submit">Create</button>
    </form>
  )
}
```

### fetch with Caching

```tsx
// By default - cached forever
const data = await fetch('https://api.example.com/data')

// Don't cache
const data = await fetch('https://api.example.com/data', { 
  cache: 'no-store' 
})

// Cache with time limit
const data = await fetch('https://api.example.com/data', { 
  next: { revalidate: 3600 }  // 1 hour
})

// Dynamic data
const data = await fetch('https://api.example.com/data', { 
  cache: 'no-store',
  next: { tags: ['products'] }
})
```

## API Routes

```ts
// src/app/api/products/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { getProducts, createProduct } from '@/lib/db'

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const category = searchParams.get('category')
  
  const products = await getProducts({ category })
  
  return NextResponse.json(products)
}

export async function POST(request: NextRequest) {
  const body = await request.json()
  
  const product = await createProduct(body)
  
  return NextResponse.json(product, { status: 201 })
}
```

## Typing

```tsx
// src/types/index.ts
export interface User {
  id: string
  name: string
  email: string
  avatar?: string
  createdAt: Date
}

export interface Product {
  id: string
  name: string
  slug: string
  description: string
  price: number
  images: string[]
  category: Category
  inStock: boolean
}

export interface Category {
  id: string
  name: string
  slug: string
}

// Generic types
export interface ApiResponse<T> {
  data: T
  message?: string
  success: boolean
}

export interface PaginatedResponse<T> {
  data: T[]
  total: number
  page: number
  pageSize: number
  totalPages: number
}
```

## Components

### Button

```tsx
// src/components/ui/Button.tsx
import { cn } from '@/lib/utils'

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  isLoading?: boolean
}

export function Button({
  className,
  variant = 'primary',
  size = 'md',
  isLoading,
  children,
  ...props
}: ButtonProps) {
  const variants = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700',
    outline: 'border border-gray-300 hover:bg-gray-50',
    ghost: 'hover:bg-gray-100',
  }

  const sizes = {
    sm: 'px-3 py-1 text-sm',
    md: 'px-4 py-2',
    lg: 'px-6 py-3 text-lg',
  }

  return (
    <button
      className={cn(
        'rounded-md font-medium transition-colors',
        variants[variant],
        sizes[size],
        isLoading && 'opacity-50 cursor-not-allowed',
        className
      )}
      disabled={isLoading}
      {...props}
    >
      {isLoading ? 'Loading...' : children}
    </button>
  )
}
```

### Form with Zod

```tsx
// src/components/forms/ProductForm.tsx
'use client'

import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { createProduct } from '@/app/actions'

const productSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  slug: z.string().min(1, 'Slug is required').regex(/^[a-z0-9-]+$/, 'Invalid slug'),
  price: z.number().positive('Price must be positive'),
  description: z.string().min(10, 'Description too short'),
})

type ProductFormData = z.infer<typeof productSchema>

export function ProductForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<ProductFormData>({
    resolver: zodResolver(productSchema),
  })

  const onSubmit = async (data: ProductFormData) => {
    await createProduct(data)
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <label htmlFor="name">Name</label>
        <input {...register('name')} id="name" />
        {errors.name && <p className="text-red-500">{errors.name.message}</p>}
      </div>

      <div>
        <label htmlFor="price">Price</label>
        <input 
          type="number" 
          {...register('price', { valueAsNumber: true })} 
          id="price" 
        />
        {errors.price && <p className="text-red-500">{errors.price.message}</p>}
      </div>

      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? 'Creating...' : 'Create Product'}
      </button>
    </form>
  )
}
```

## Authentication

```tsx
// src/lib/auth.ts
import { NextAuthOptions } from 'next-auth'
import CredentialsProvider from 'next-auth/providers/credentials'
import { compare } from 'bcryptjs'
import { db } from '@/lib/db'

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        email: { label: 'Email', type: 'email' },
        password: { label: 'Password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null
        }

        const user = await db.user.findUnique({
          where: { email: credentials.email },
        })

        if (!user || !user.password) {
          return null
        }

        const isValid = await compare(credentials.password, user.password)

        if (!isValid) {
          return null
        }

        return {
          id: user.id,
          email: user.email,
          name: user.name,
        }
      },
    }),
  ],
  session: {
    strategy: 'jwt',
  },
  pages: {
    signIn: '/login',
  },
}
```

## Middleware

```ts
// src/middleware.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'
import { getToken } from 'next-auth/jwt'

export async function middleware(request: NextRequest) {
  const token = await getToken({ req: request, secret: process.env.NEXTAUTH_SECRET })
  
  const { pathname } = request.nextUrl

  // Protected routes
  if (pathname.startsWith('/dashboard') || pathname.startsWith('/profile')) {
    if (!token) {
      const url = new URL('/login', request.url)
      url.searchParams.set('callbackUrl', pathname)
      return NextResponse.redirect(url)
    }
  }

  // Redirect authorized users
  if (pathname === '/login' || pathname === '/register') {
    if (token) {
      return NextResponse.redirect(new URL('/dashboard', request.url))
    }
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/dashboard/:path*', '/profile/:path*', '/login', '/register'],
}
```

## Optimization

### Images

```tsx
import Image from 'next/image'

export function ProductImage({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={400}
      height={300}
      className="object-cover"
      placeholder="blur"
      blurDataURL="data:image/..."
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
    />
  )
}
```

### Fonts

```tsx
// src/app/layout.tsx
import { Inter, Roboto_Mono } from 'next/font/google'

const inter = Inter({ 
  subsets: ['latin'],
  variable: '--font-inter',
})

const robotoMono = Roboto_Mono({
  subsets: ['latin'],
  variable: '--font-roboto-mono',
})

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <html className={`${inter.variable} ${robotoMono.variable}`}>
      <body>{children}</body>
    </html>
  )
}
```

## Testing

```tsx
// __tests__/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from '@/components/ui/Button'

describe('Button', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button')).toBeInTheDocument()
  })

  it('handles click', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click me</Button>)
    fireEvent.click(screen.getByRole('button'))
    expect(handleClick).toHaveBeenCalled()
  })

  it('shows loading state', () => {
    render(<Button isLoading>Click me</Button>)
    expect(screen.getByText('Loading...')).toBeInTheDocument()
  })
})
```

## Docker

```dockerfile
# Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/app
      - NEXTAUTH_SECRET=secret
    depends_on:
      - db

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## Best Practices

1. **Use Server Components** - by default, where possible
2. **Minimize Client Components** - only for interactivity
3. **Type everything** - strict TypeScript
4. **Validate data** - Zod for schemas
5. **Use Server Actions** - for mutations
6. **Optimize images** - Next.js Image
7. **Cache data** - fetch with revalidate
8. **Test** - Jest + React Testing Library
9. **Follow structure** - organize by features
10. **Monitor** - Vercel Analytics
