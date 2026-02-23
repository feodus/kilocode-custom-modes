---
name: typescript-best-practices
description: TypeScript development best practices. Use this skill when working with TypeScript projects to write safe, maintainable, and idiomatic code.
---

# TypeScript Best Practices

## TypeScript Setup

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    
    // Strict checks
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "useUnknownInCatchVariables": true,
    "alwaysStrict": true,
    
    // Additional checks
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "noPropertyAccessFromIndexSignature": true,
    "exactOptionalPropertyTypes": true,
    
    // Modules
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,
    
    // Paths
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"],
      "@components/*": ["src/components/*"],
      "@utils/*": ["src/utils/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

## Types

### Primitives and Literal Types

```typescript
// Good
let id: string = 'abc123'
let count: number = 42
let active: boolean = true
let status: 'pending' | 'approved' | 'rejected' = 'pending'

// Types for constants
type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE'
type LogLevel = 'debug' | 'info' | 'warn' | 'error'

// Bad - any
// let data: any = getData()  // Avoid!
```

### Union and Intersection Types

```typescript
// Union - one of
type StringOrNumber = string | number
type Result<T> = { success: true; data: T } | { success: false; error: string }

function handleResult<T>(result: Result<T>) {
  if (result.success) {
    console.log(result.data) // TypeScript knows data exists
  } else {
    console.log(result.error) // TypeScript knows error exists
  }
}

// Intersection - combination
type NamedEntity = { name: string }
type IdentifiedEntity = { id: string }
type Entity = NamedEntity & IdentifiedEntity

const entity: Entity = { name: 'User', id: '123' }
```

### Generic Types

```typescript
// Generic functions
function first<T>(arr: T[]): T | undefined {
  return arr[0]
}

// Generic classes
class Container<T> {
  private value: T
  
  constructor(value: T) {
    this.value = value
  }
  
  getValue(): T {
    return this.value
  }
  
  map<U>(fn: (value: T) => U): U {
    return fn(this.value)
  }
}

// Generic constraints
interface HasLength {
  length: number
}

function logLength<T extends HasLength>(item: T): number {
  return item.length
}

logLength('hello') // OK
logLength([1, 2, 3]) // OK
logLength({ length: 10 }) // OK
// logLength(123) // Error - number has no length
```

### Utility Types

```typescript
// Partial - all properties optional
interface User {
  id: string
  name: string
  email: string
}

type PartialUser = Partial<User>
// { id?: string; name?: string; email?: string }

// Required - all properties required
type RequiredUser = Required<PartialUser>

// Readonly - read only
type ReadonlyUser = Readonly<User>

// Pick - select fields
type UserPreview = Pick<User, 'id' | 'name'>
// { id: string; name: string }

// Omit - exclude fields
type UserWithoutEmail = Omit<User, 'email'>

// Record - object with keys K and values V
type UserRoles = Record<string, 'admin' | 'user' | 'guest'>

// Mapped types
type Nullable<T> = { [K in keyof T]: T[K] | null }

type Optional<T> = {
  [K in keyof T]?: T[K]
}
```

## Interfaces vs Types

```typescript
// Interface - for object types, extensible
interface User {
  id: string
  name: string
  email: string
}

interface User {
  avatar?: string // Extension
}

// Type - for unions, tuples, primitives
type Status = 'active' | 'inactive'
type Point = [number, number]
type StringOrNumber = string | number

// Combination
type UserWithRole = User & { role: 'admin' | 'user' }
```

## Functions

### Function Typing

```typescript
// Typing parameters and return value
function greet(name: string): string {
  return `Hello, ${name}!`
}

// Arrow functions
const add = (a: number, b: number): number => a + b

// Functions with optional parameters
function createUser(name: string, age?: number): User {
  return {
    id: crypto.randomUUID(),
    name,
    age,
  }
}

// Default parameters
function paginate(items: any[], page = 1, limit = 10) {
  return items.slice((page - 1) * limit, page * limit)
}

// Rest parameters
function sum(...numbers: number[]): number {
  return numbers.reduce((a, b) => a + b, 0)
}

// Type guard
function isString(value: unknown): value is string {
  return typeof value === 'string'
}
```

### Function Overloading

```typescript
// Overloads
function parseJSON(input: string): object
function parseJSON<T>(input: string): T

function parseJSON<T>(input: string): T | object {
  const result = JSON.parse(input)
  return result as T
}

const user = parseJSON<User>('{"name": "John"}')
```

## Classes

```typescript
// Class typing
class UserService {
  private readonly apiUrl: string
  private users: Map<string, User> = new Map()
  
  constructor(apiUrl: string) {
    this.apiUrl = apiUrl
  }
  
  async getUser(id: string): Promise<User | null> {
    return this.users.get(id) ?? null
  }
  
  async createUser(data: CreateUserDTO): Promise<User> {
    const user: User = {
      id: crypto.randomUUID(),
      ...data,
      createdAt: new Date(),
    }
    this.users.set(user.id, user)
    return user
  }
  
  get userCount(): number {
    return this.users.size
  }
}

// Inheritance
class AdminUserService extends UserService {
  async deleteUser(id: string): Promise<void> {
    // Additional logic for admins
    return super.deleteUser(id)
  }
}

// Abstract classes
abstract class BaseService {
  abstract fetch(): Promise<any>
  
  protected log(message: string): void {
    console.log(`[${new Date().toISOString()}] ${message}`)
  }
}
```

## Error handling

```typescript
// Result pattern
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E }

async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const response = await fetch(`/api/users/${id}`)
    if (!response.ok) {
      return { ok: false, error: new Error(`HTTP ${response.status}`) }
    }
    const user = await response.json()
    return { ok: true, value: user }
  } catch (error) {
    return { ok: false, error: error as Error }
  }
}

// Usage
const result = await fetchUser('123')
if (result.ok) {
  console.log(result.value)
} else {
  console.error(result.error)
}
```

## Modules

```typescript
// Type exports
export type { User, CreateUserDTO, UpdateUserDTO }
export interface Role {
  id: string
  name: string
}

// Re-exports
export { UserService } from './user.service'
export * from './types'

// barrel file
// index.ts
export { UserService } from './user.service'
export { UserController } from './user.controller'
export type { User } from './types'
```

## Configuration types

```typescript
// type-safe configuration
interface AppConfig {
  server: {
    port: number
    host: string
  }
  database: {
    url: string
    pool: {
      min: number
      max: number
    }
  }
  features: {
    darkMode: boolean
    analytics: boolean
  }
}

const config: AppConfig = {
  server: {
    port: process.env.PORT ? Number(process.env.PORT) : 3000,
    host: process.env.HOST || 'localhost',
  },
  database: {
    url: process.env.DATABASE_URL!,
    pool: {
      min: 2,
      max: 10,
    },
  },
  features: {
    darkMode: process.env.DARK_MODE === 'true',
    analytics: process.env.ANALYTICS === 'true',
  },
}
```

## Type Testing

```typescript
// Type checking at compile time
type AssertEqual<T, U> = [T] extends [U] ? [U] extends [T] ? true : false : false

type _test = AssertEqual<{ a: string }, { a: string }> // true

//satisfies
const config = {
  port: 3000,
  env: 'development',
} as const satisfies Record<string, number | string>
```

## Best Practices

1. **Strict mode** - `strict: true` in tsconfig
2. **Avoid any** - use `unknown` + type guards
3. **Name types** - User, UserDTO, UserVO
4. **Generics** - for reusable code
5. **Utility types** - Partial, Pick, Omit
6. **Destructuring** - with annotations
7. **readonly** - for immutable data
8. **Functions** - parameter and return typing
9. **Error handling** - Result pattern
10. **Barrel files** - for clean exports
