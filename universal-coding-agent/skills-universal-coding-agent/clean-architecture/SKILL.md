---
name: clean-architecture
description: Clean Architecture and design patterns. Use this skill when designing scalable applications, implementing dependency injection, and creating loosely coupled code.
---

# Clean Architecture

## Principles

```
src/
├── domain/           # Entities and business rules (innermost layer)
│   ├── entities/     # Business objects
│   ├── value-objects/
│   └── interfaces/  # Abstract repositories
│
├── application/      # Use Cases - apply business rules
│   ├── use-cases/
│   ├── dto/
│   ├── interfaces/  # Service interfaces
│   └── exceptions/
│
├── infrastructure/   # External dependencies
│   ├── database/    # ORM, migrations
│   ├── external/    # API clients
│   ├── services/   # External services implementations
│   └── config/
│
├── presentation/    # UI/API layer
│   ├── controllers/
│   ├── routes/
│   ├── middleware/
│   └── dto/         # Request/Response objects
│
└── shared/         # Shared utilities
    ├── types/
    ├── utils/
    └── constants/
```

## Domain Layer

```typescript
// domain/entities/User.ts
export interface User {
  id: string
  email: Email
  name: string
  createdAt: Date
  updatedAt: Date
}

// domain/value-objects/Email.ts
export class Email {
  private readonly value: string
  
  private constructor(value: string) {
    this.value = value
  }
  
  static create(value: string): Email {
    if (!Email.isValid(value)) {
      throw new Error('Invalid email format')
    }
    return new Email(value.toLowerCase())
  }
  
  static isValid(value: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(value)
  }
  
  getValue(): string {
    return this.value
  }
}

// domain/interfaces/UserRepository.ts
export interface UserRepository {
  findById(id: string): Promise<User | null>
  findByEmail(email: Email): Promise<User | null>
  save(user: User): Promise<User>
  delete(id: string): Promise<void>
}
```

## Application Layer

```typescript
// application/use-cases/CreateUserUseCase.ts
import { UserRepository } from '../../domain/interfaces/UserRepository'
import { User } from '../../domain/entities/User'
import { Email } from '../../domain/value-objects/Email'

export interface CreateUserInput {
  email: string
  name: string
  password: string
}

export interface CreateUserOutput {
  user: User
}

export class CreateUserUseCase {
  constructor(private readonly userRepository: UserRepository) {}
  
  async execute(input: CreateUserInput): Promise<CreateUserOutput> {
    // 1. Validation
    const email = Email.create(input.email)
    
    // 2. Check existing user
    const existingUser = await this.userRepository.findByEmail(email)
    if (existingUser) {
      throw new Error('User already exists')
    }
    
    // 3. Create entity
    const user: User = {
      id: crypto.randomUUID(),
      email,
      name: input.name,
      createdAt: new Date(),
      updatedAt: new Date(),
    }
    
    // 4. Save
    const savedUser = await this.userRepository.save(user)
    
    return { user: savedUser }
  }
}
```

```typescript
// application/use-cases/GetUserUseCase.ts
export interface GetUserInput {
  id: string
}

export interface GetUserOutput {
  user: {
    id: string
    email: string
    name: string
    createdAt: Date
  } | null
}

export class GetUserUseCase {
  constructor(private readonly userRepository: UserRepository) {}
  
  async execute(input: GetUserInput): Promise<GetUserOutput> {
    const user = await this.userRepository.findById(input.id)
    
    if (!user) {
      return { user: null }
    }
    
    return {
      user: {
        id: user.id,
        email: user.email.getValue(),
        name: user.name,
        createdAt: user.createdAt,
      },
    }
  }
}
```

## Infrastructure Layer

```typescript
// infrastructure/database/PrismaUserRepository.ts
import { UserRepository } from '../../domain/interfaces/UserRepository'
import { User } from '../../domain/entities/User'
import { Email } from '../../domain/value-objects/Email'
import { PrismaClient } from '@prisma/client'

export class PrismaUserRepository implements UserRepository {
  constructor(private readonly prisma: PrismaClient) {}
  
  async findById(id: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({ where: { id } })
    if (!user) return null
    
    return this.mapToEntity(user)
  }
  
  async findByEmail(email: Email): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: { email: email.getValue() },
    })
    if (!user) return null
    
    return this.mapToEntity(user)
  }
  
  async save(user: User): Promise<User> {
    const saved = await this.prisma.user.upsert({
      where: { id: user.id },
      create: {
        id: user.id,
        email: user.email.getValue(),
        name: user.name,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
      update: {
        name: user.name,
        updatedAt: user.updatedAt,
      },
    })
    
    return this.mapToEntity(saved)
  }
  
  async delete(id: string): Promise<void> {
    await this.prisma.user.delete({ where: { id } })
  }
  
  private mapToEntity(dbUser: any): User {
    return {
      id: dbUser.id,
      email: Email.create(dbUser.email),
      name: dbUser.name,
      createdAt: dbUser.createdAt,
      updatedAt: dbUser.updatedAt,
    }
  }
}
```

```typescript
// infrastructure/config/container.ts
import { PrismaClient } from '@prisma/client'
import { UserRepository } from '../../domain/interfaces/UserRepository'
import { PrismaUserRepository } from '../database/PrismaUserRepository'
import { CreateUserUseCase } from '../../application/use-cases/CreateUserUseCase'
import { GetUserUseCase } from '../../application/use-cases/GetUserUseCase'

// Dependency Injection Container
class Container {
  private static instance: Container
  
  private _prisma?: PrismaClient
  private _userRepository?: UserRepository
  
  private constructor() {}
  
  static getInstance(): Container {
    if (!Container.instance) {
      Container.instance = new Container()
    }
    return Container.instance
  }
  
  get prisma(): PrismaClient {
    if (!this._prisma) {
      this._prisma = new PrismaClient()
    }
    return this._prisma
  }
  
  get userRepository(): UserRepository {
    if (!this._userRepository) {
      this._userRepository = new PrismaUserRepository(this.prisma)
    }
    return this._userRepository
  }
  
  get createUserUseCase(): CreateUserUseCase {
    return new CreateUserUseCase(this.userRepository)
  }
  
  get getUserUseCase(): GetUserUseCase {
    return new GetUserUseCase(this.userRepository)
  }
}

export const container = Container.getInstance()
```

## Presentation Layer

```typescript
// presentation/controllers/UserController.ts
import { Request, Response, NextFunction } from 'express'
import { container } from '../../infrastructure/config/container'

export class UserController {
  async create(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, name, password } = req.body
      
      const useCase = container.createUserUseCase
      const result = await useCase.execute({ email, name, password })
      
      res.status(201).json(result.user)
    } catch (error) {
      next(error)
    }
  }
  
  async get(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params
      
      const useCase = container.getUserUseCase
      const result = await useCase.execute({ id })
      
      if (!result.user) {
        return res.status(404).json({ error: 'User not found' })
      }
      
      res.json(result.user)
    } catch (error) {
      next(error)
    }
  }
}
```

## Dependency Rule

```
┌─────────────────────────────────────────────┐
│           Presentation Layer               │
│  (Controllers, Routes, Middleware)         │
└─────────────────────┬───────────────────────┘
                      │ depends on
                      ▼
┌─────────────────────────────────────────────┐
│           Application Layer                 │
│     (Use Cases, DTO, Interfaces)            │
└─────────────────────┬───────────────────────┘
                      │ depends on
                      ▼
┌─────────────────────────────────────────────┐
│              Domain Layer                    │
│  (Entities, Value Objects, Interfaces)       │
└─────────────────────────────────────────────┘
                      ▲
                      │ does not depend
┌─────────────────────┴───────────────────────┐
│          Infrastructure Layer               │
│ (DB, External APIs, Implementations)         │
└─────────────────────────────────────────────┘
```

## Patterns

### Repository Pattern

```typescript
// Data access abstraction
interface Repository<T> {
  findById(id: string): Promise<T | null>
  findAll(): Promise<T[]>
  save(entity: T): Promise<T>
  delete(id: string): Promise<void>
}
```

### Service Layer

```typescript
// Business logic coordinating multiple repositories
class OrderService {
  constructor(
    private orderRepo: OrderRepository,
    private productRepo: ProductRepository,
    private emailService: EmailService
  ) {}
  
  async createOrder(userId: string, items: OrderItem[]): Promise<Order> {
    // Validation
    // Calculate total
    // Create order
    // Send email
  }
}
```

### Factory Pattern

```typescript
// Creating complex objects
class UserFactory {
  static create(data: CreateUserDTO): User {
    const email = Email.create(data.email)
    const passwordHash = Password.createHash(data.password)
    
    return {
      id: crypto.randomUUID(),
      email,
      passwordHash,
      ...data
    }
  }
}
```

### DTO (Data Transfer Object)

```typescript
// For transferring data between layers
interface CreateUserDTO {
  email: string
  name: string
  password: string
}

interface UserResponseDTO {
  id: string
  email: string
  name: string
  createdAt: string
}
```

### Mapper

```typescript
// Transformation between layers
class UserMapper {
  static toDTO(user: User): UserResponseDTO {
    return {
      id: user.id,
      email: user.email.getValue(),
      name: user.name,
      createdAt: user.createdAt.toISOString(),
    }
  }
}
```

## Testing

```typescript
// __tests__/application/CreateUserUseCase.test.ts
import { CreateUserUseCase } from '../../application/use-cases/CreateUserUseCase'
import { UserRepository } from '../../domain/interfaces/UserRepository'

// Mock repository
class MockUserRepository implements UserRepository {
  private users: Map<string, any> = new Map()
  
  async findById(id: string) { return this.users.get(id) || null }
  async findByEmail() { return null }
  async save(user: any) { this.users.set(user.id, user); return user }
  async delete() {}
}

describe('CreateUserUseCase', () => {
  it('should create a user', async () => {
    const repository = new MockUserRepository()
    const useCase = new CreateUserUseCase(repository)
    
    const result = await useCase.execute({
      email: 'test@example.com',
      name: 'Test User',
      password: 'password123',
    })
    
    expect(result.user.email.getValue()).toBe('test@example.com')
  })
})
```

## Best Practices

1. **Dependency Rule** - inner layers do not depend on outer layers
2. **Dependency Injection** - inject via constructor
3. **Interface segregation** - small interfaces
4. **Single Responsibility** - one use case = one operation
5. **Value Objects** - immutable types for validation
6. **Domain Events** - for communication between bounded contexts
7. **Repository** - abstraction over data source
8. **Testing** - unit tests for domain and use cases without external dependencies
9. **Entities** - have identity
10. **Aggregate Root** - controls transactional boundaries
