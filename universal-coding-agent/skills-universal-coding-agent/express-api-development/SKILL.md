---
name: express-api-development
description: REST API development with Node.js and Express. Use this skill when creating server applications, API endpoints, middleware, and database integrations.
---

# Express.js Development Guide

## Project Setup

```bash
# Create project
npm init -y

# Install dependencies
npm install express cors helmet morgan dotenv

# Install dev dependencies
npm install -D typescript @types/node @types/express @types/cors ts-node nodemon

# Initialize TypeScript
npx tsc --init
```

## Basic Structure

```
src/
├── app.ts                 # Express app
├── server.ts              # Entry point
├── config/
│   ├── database.ts       # Database config
│   └── env.ts           # Environment variables
├── routes/
│   ├── index.ts
│   ├── users.ts
│   └── products.ts
├── controllers/
│   ├── usersController.ts
│   └── productsController.ts
├── models/
│   ├── User.ts
│   └── Product.ts
├── middleware/
│   ├── auth.ts
│   ├── validation.ts
│   └── errorHandler.ts
├── services/
│   ├── userService.ts
│   └── productService.ts
├── utils/
│   ├── ApiError.ts
│   └── helpers.ts
└── types/
    └── index.ts
```

## Basic Application

```typescript
// src/app.ts
import express, { Application, Request, Response, NextFunction } from 'express'
import cors from 'cors'
import helmet from 'helmet'
import morgan from 'morgan'
import dotenv from 'dotenv'

dotenv.config()

const app: Application = express()

// Middleware
app.use(helmet())
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  credentials: true,
}))
app.use(morgan('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// Routes
app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() })
})

// 404 handler
app.use((req: Request, res: Response) => {
  res.status(404).json({ error: 'Not found' })
})

// Error handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack)
  res.status(500).json({ error: 'Internal server error' })
})

export default app
```

```typescript
// src/server.ts
import app from './app'

const PORT = process.env.PORT || 3000

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
```

## CRUD Examples

```typescript
// src/routes/users.ts
import { Router, Request, Response, NextFunction } from 'express'
import { UserService } from '../services/userService'

const router = Router()
const userService = new UserService()

// GET all users
router.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { page = 1, limit = 10, search = '' } = req.query
    
    const users = await userService.findAll({
      page: Number(page),
      limit: Number(limit),
      search: String(search),
    })
    
    res.json(users)
  } catch (error) {
    next(error)
  }
})

// GET single user
router.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await userService.findById(req.params.id)
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' })
    }
    
    res.json(user)
  } catch (error) {
    next(error)
  }
})

// POST create user
router.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await userService.create(req.body)
    res.status(201).json(user)
  } catch (error) {
    next(error)
  }
})

// PUT update user
router.put('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await userService.update(req.params.id, req.body)
    res.json(user)
  } catch (error) {
    next(error)
  }
})

// DELETE user
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await userService.delete(req.params.id)
    res.status(204).send()
  } catch (error) {
    next(error)
  }
})

export default router
```

## Middleware

```typescript
// src/middleware/auth.ts
import { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken'
import { ApiError } from '../utils/ApiError'

export interface AuthRequest extends Request {
  user?: {
    id: string
    email: string
    role: string
  }
}

export const authenticate = (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const authHeader = req.headers.authorization
    
    if (!authHeader?.startsWith('Bearer ')) {
      throw new ApiError(401, 'No token provided')
    }
    
    const token = authHeader.split(' ')[1]
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any
    
    req.user = {
      id: decoded.sub,
      email: decoded.email,
      role: decoded.role,
    }
    
    next()
  } catch (error) {
    next(new ApiError(401, 'Invalid token'))
  }
}

export const authorize = (...roles: string[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return next(new ApiError(401, 'Not authenticated'))
    }
    
    if (!roles.includes(req.user.role)) {
      return next(new ApiError(403, 'Not authorized'))
    }
    
    next()
  }
}
```

```typescript
// src/middleware/validation.ts
import { Request, Response, NextFunction } from 'express'
import Joi from 'joi'
import { ApiError } from '../utils/ApiError'

export const validate = (schema: Joi.ObjectSchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const { error } = schema.validate(req.body, { abortEarly: false })
    
    if (error) {
      const errors = error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message,
      }))
      return next(new ApiError(400, 'Validation failed', errors))
    }
    
    next()
  }
}

// Validation schemas
export const schemas = {
  createUser: Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().min(8).required(),
    name: Joi.string().min(2).required(),
  }),
  
  updateUser: Joi.object({
    email: Joi.string().email(),
    name: Joi.string().min(2),
    bio: Joi.string().max(500),
  }),
  
  login: Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().required(),
  }),
}
```

## Services

```typescript
// src/services/userService.ts
import { Db } from '../config/database'
import { ApiError } from '../utils/ApiError'

export class UserService {
  async findAll(options: { page: number; limit: number; search: string }) {
    const { page, limit, search } = options
    const offset = (page - 1) * limit
    
    const where = search 
      ? { 
          OR: [
            { name: { contains: search, mode: 'insensitive' } },
            { email: { contains: search, mode: 'insensitive' } },
          ]
        }
      : {}
    
    const [users, total] = await Promise.all([
      Db.user.findMany({
        where,
        skip: offset,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id: true,
          email: true,
          name: true,
          role: true,
          createdAt: true,
        },
      }),
      Db.user.count({ where }),
    ])
    
    return {
      data: users,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    }
  }
  
  async findById(id: string) {
    return Db.user.findUnique({
      where: { id },
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
        createdAt: true,
      },
    })
  }
  
  async create(data: { email: string; password: string; name: string }) {
    const existing = await Db.user.findUnique({
      where: { email: data.email },
    })
    
    if (existing) {
      throw new ApiError(400, 'Email already exists')
    }
    
    const hashedPassword = await bcrypt.hash(data.password, 12)
    
    return Db.user.create({
      data: {
        ...data,
        password: hashedPassword,
      },
    })
  }
  
  async update(id: string, data: Partial<{ email: string; name: string; bio: string }>) {
    return Db.user.update({
      where: { id },
      data,
    })
  }
  
  async delete(id: string) {
    await Db.user.delete({ where: { id } })
  }
}
```

## Authentication

```typescript
// src/controllers/authController.ts
import { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken'
import bcrypt from 'bcryptjs'
import { UserService } from '../services/userService'
import { ApiError } from '../utils/ApiError'

const userService = new UserService()

export class AuthController {
  async register(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, password, name } = req.body
      
      const user = await userService.create({ email, password, name })
      
      const token = jwt.sign(
        { sub: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET!,
        { expiresIn: '7d' }
      )
      
      res.status(201).json({
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
        },
        token,
      })
    } catch (error) {
      next(error)
    }
  }
  
  async login(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, password } = req.body
      
      const user = await userService.findByEmail(email)
      
      if (!user || !(await bcrypt.compare(password, user.password))) {
        throw new ApiError(401, 'Invalid credentials')
      }
      
      const token = jwt.sign(
        { sub: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET!,
        { expiresIn: '7d' }
      )
      
      res.json({
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
        },
        token,
      })
    } catch (error) {
      next(error)
    }
  }
  
  async me(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const user = await userService.findById(req.user!.id)
      res.json(user)
    } catch (error) {
      next(error)
    }
  }
}
```

## Rate Limiting

```typescript
// src/middleware/rateLimiter.ts
import rateLimit from 'express-rate-limit'

export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: { error: 'Too many attempts, please try again later' },
  standardHeaders: true,
  legacyHeaders: false,
})

export const apiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100, // 100 requests
  message: { error: 'Too many requests' },
})
```

## API Documentation (Swagger)

```typescript
// src/config/swagger.ts
import swaggerJsdoc from 'swagger-jsdoc'

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'My API',
      version: '1.0.0',
      description: 'API documentation',
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
    security: [{ bearerAuth: [] }],
  },
  apis: ['./src/routes/*.ts'],
}

export const specs = swaggerJsdoc(options)
```

```typescript
// app.ts - adding swagger
import swaggerUi from 'swagger-ui-express'
import { specs } from './config/swagger'

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs))
```

## Testing

```typescript
// __tests__/users.test.ts
import request from 'supertest'
import app from '../src/app'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

describe('Users API', () => {
  beforeAll(async () => {
    // Clear DB
    await prisma.user.deleteMany()
  })
  
  afterAll(async () => {
    await prisma.$disconnect()
  })
  
  describe('POST /api/users', () => {
    it('should create a user', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        })
      
      expect(response.status).toBe(201)
      expect(response.body).toHaveProperty('id')
      expect(response.body.email).toBe('test@example.com')
    })
    
    it('should return 400 for invalid data', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({ email: 'invalid' })
      
      expect(response.status).toBe(400)
    })
  })
  
  describe('GET /api/users', () => {
    it('should return users list', async () => {
      const response = await request(app)
        .get('/api/users')
      
      expect(response.status).toBe(200)
      expect(response.body).toHaveProperty('data')
    })
  })
})
```

## Docker

```dockerfile
# Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["node", "dist/server.js"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/api
      - JWT_SECRET=secret
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: api
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d api"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

## Best Practices

1. **Structure** - controllers, services, models
2. **Validate** - use Joi/Zod
3. **Authenticate** - JWT with refresh tokens
4. **Handle errors** - centralized error handler
5. **Log** - morgan + pino
6. **Cache** - Redis for frequent queries
7. **Document** - Swagger/OpenAPI
8. **Test** - Jest + Supertest
9. **Rate limit** - DDoS protection
10. **TypeScript** - strict typing
