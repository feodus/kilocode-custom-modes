# Universal Coding Agent Setup with Skills

> **Meta:** v2.0.0 | 15.02.2026

## Overview

This instruction describes how to set up and use the **Universal Coding Agent** mode with multi-technology skills in a new project.

## Components

### 1. Universal Coding Agent (mode)

File: [`universal-coding-agent_v1-4.yaml`](universal-coding-agent_v1-4.yaml)

- Extended AI agent for universal development
- Support for all major programming languages and frameworks
- Automatic integration with specialized skills

### 2. Skills

Directory: `skills-universal-coding-agent/`

**17 skills divided by categories:**

| Category | Skills |
|----------|--------|
| **Backend (Python)** | `django-development`, `fastapi-development`, `python-project-setup`, `python-testing`, `moex-bond-api-python` |
| **Backend (JS/TS)** | `express-api-development`, `typescript-best-practices` |
| **Frontend** | `react-nextjs-development`, `tailwind-css` |
| **DevOps & CI/CD** | `docker-kubernetes`, `github-actions-ci`, `gitlab-ci-cd` |
| **Database** | `postgresql-development` |
| **Architecture & API** | `clean-architecture`, `rest-api-design` |
| **Specialized** | `telegram-bot-development`, `excel-vba-development` |

---

## Step 1: Copying Files to a New Project

### 1.1 Copying the Mode

Copy the [`universal-coding-agent_v1-4.yaml`](universal-coding-agent_v1-4.yaml) file to your project root:

```
your-project/
├── .kilocodemodes              # Add mode configuration
└── ... (other project files)
```

### 1.2 Copying Skills

Create the `.kilocode/skills-universal-coding-agent/` directory and copy the required skills:

```
your-project/
└── .kilocode/
    └── skills-universal-coding-agent/
        ├── clean-architecture/
        │   └── SKILL.md
        ├── django-development/
        │   └── SKILL.md
        ├── docker-kubernetes/
        │   └── SKILL.md
        ├── ... (other skills)
        └── typescript-best-practices/
            └── SKILL.md
```

**Note:** You can copy only the skills that are relevant to your project.

---

## Step 2: Integrating the Mode into the Project

### 2.1 Adding the Mode to .kilocodemodes

Open (or create) the `.kilocodemodes` file in your project root:

```yaml
customModes:
  - slug: universal-coding-agent
    name: Universal Coding Agent
    iconName: codicon-code
    description: A powerful universal coding agent with extended capabilities covering all major frameworks, best practices, and development workflows - Updated v1.4, 15.02.2026
    whenToUse: Use this mode for comprehensive coding tasks requiring universal language support, advanced tool usage, and cross-framework expertise. Ideal for complex development scenarios spanning multiple technologies.
    roleDefinition: |
      # Universal Coding Agent

      ## Identity and Role
      You are a Universal Coding Agent, an advanced AI coding assistant with extensive knowledge across all programming languages, frameworks, and development practices.

      ## Technology Agnostic Approach
      - Support all major programming languages: JavaScript/TypeScript, Python, Java, C#, Go, Rust, PHP, Ruby, etc.
      - Framework support includes: React, Vue, Angular, Next.js, Svelte, Node.js, Django, Flask, FastAPI, Spring Boot, etc.
      - Follow language-specific best practices and idioms

      [Full roleDefinition content from universal-coding-agent_v1-4.yaml]
    groups:
      - read
      - edit
      - browser
      - command
      - mcp
    source: project
```

---

## Step 3: Verifying Functionality

### 3.1 Reloading VS Code

After copying the files, reload VS Code:

- Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows)
- Type "Developer: Reload Window"
- Press Enter

### 3.2 Verifying Mode Availability

1. Open KiloCode in VS Code
2. **Universal Coding Agent** should appear in the mode list
3. Select this mode

### 3.3 Verifying Skills

To verify skill availability, ask the agent:

- "Какие навыки у тебя доступны?"
- "What skills do you have available?"

The agent should list the installed skills.

---

## Step 4: Using Skills

### 4.1 Automatic Activation

Skills are automatically activated when the request matches their description:

| Skill | Example Requests |
|-------|------------------|
| `react-nextjs-development` | "create Next.js app", "add App Router" |
| `fastapi-development` | "create API", "develop FastAPI endpoint" |
| `django-development` | "create Django project", "add model" |
| `docker-kubernetes` | "containerize application", "create Dockerfile" |
| `github-actions-ci` | "setup CI/CD", "create pipeline" |
| `telegram-bot-development` | "create Telegram bot", "add handler" |
| `postgresql-development` | "optimize query", "create index" |
| `tailwind-css` | "style component", "add Tailwind" |

### 4.2 Explicit Skill Invocation

You can explicitly tell the agent to use a specific skill:

```
Use the docker-kubernetes skill to create a Docker Compose setup
```

```
Use the react-nextjs-development skill to create a component
```

---

## Directory Structure After Setup

```
your-project/
├── .kilocodemodes                    # Mode configuration
├── .kilocode/
│   └── skills-universal-coding-agent/
│       ├── clean-architecture/
│       │   └── SKILL.md
│       ├── django-development/
│       │   └── SKILL.md
│       ├── docker-kubernetes/
│       │   └── SKILL.md
│       └── ... (other skills)
├── src/                              # Source code
├── tests/                            # Tests
├── pyproject.toml / package.json     # Project configuration
└── README.md
```

---

## Troubleshooting

### Mode Not Displayed

**Solution:**
1. Check YAML syntax in `.kilocodemodes`
2. Ensure the mode file is in the correct location
3. Reload VS Code

### Skills Not Activating

**Solution:**
1. Check for `.kilocode/skills-universal-coding-agent/` directory
2. Ensure `SKILL.md` files are inside subdirectories
3. Check that the `name` field in frontmatter matches the directory name
4. Reload VS Code

### Skills Not Working Correctly

**Solution:**
1. Check frontmatter format in each `SKILL.md`
2. Ensure required fields `name` and `description` are present
3. Check Output panel: `View → Output → "Kilo Code"`

---

## Extending the Skill Set

You can add your own skills to the `.kilocode/skills-universal-coding-agent/` directory:

### Example: Creating a New Skill

1. Create a directory:
   ```
   .kilocode/skills-universal-coding-agent/my-custom-skill/
   ```

2. Create a `SKILL.md` file:
   ```markdown
   ---
   name: my-custom-skill
   description: Description of the skill and when to use it. Include keywords for automatic activation.
   ---

   # My Custom Skill

   Detailed instructions for the agent...

   ## Usage Examples
   - Example 1
   - Example 2
   ```

3. Reload VS Code

---

## Global Skills (Optional)

To use skills across all projects, create a global skills directory:

**Mac/Linux:**
```
~/.kilocode/skills-universal-coding-agent/
```

**Windows:**
```
C:\Users\YourUsername\.kilocode\skills-universal-coding-agent\
```

**Priority:** Project skills override global skills with the same name.

---

## Complete Skill List

| Skill | Description |
|-------|-------------|
| `clean-architecture` | Clean architecture principles for application design |
| `django-development` | Django development with best practices |
| `docker-kubernetes` | Containerization and orchestration with Docker and Kubernetes |
| `excel-vba-development` | VBA solutions for Microsoft Excel |
| `express-api-development` | REST API development with Express.js |
| `fastapi-development` | API development with FastAPI |
| `github-actions-ci` | CI/CD setup with GitHub Actions |
| `gitlab-ci-cd` | CI/CD setup with GitLab CI/CD |
| `moex-bond-api-python` | Moscow Exchange API (bonds) |
| `postgresql-development` | PostgreSQL, query optimization |
| `python-project-setup` | Python project setup |
| `python-testing` | Python application testing |
| `react-nextjs-development` | React and Next.js development |
| `rest-api-design` | REST API design |
| `tailwind-css` | Styling with Tailwind CSS |
| `telegram-bot-development` | Telegram bot development with CI/CD |
| `typescript-best-practices` | TypeScript best practices |

---

## Conclusion

After completing all steps, you will have a fully configured **Universal Coding Agent** with multi-technology skills. The agent will automatically use appropriate skills depending on the task context.

### Key Benefits

1. **Versatility** — Support for 17+ technologies and frameworks
2. **Automatic Activation** — Skills trigger based on request context
3. **Extensibility** — Ability to add your own skills
4. **Consistency** — Unified standards for different project types
5. **Cross-framework Expertise** — Best practices for each technology
