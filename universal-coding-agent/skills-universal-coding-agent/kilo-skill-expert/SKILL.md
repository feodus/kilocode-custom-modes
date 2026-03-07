---
name: kilo-skill-expert
description: Use this skill when you need to create, edit, or debug skills for KiloCode. The skill helps structure SKILL.md, implement progressive disclosure principles, and separate deterministic tasks from cognitive ones.
license: MIT
compatibility: KiloCode CLI v1.0+, VS Code Extension
metadata:
  author: "feodus"
  version: "1.2.0"
  category: development
  
---

# KiloCode Skill Development Expert

## About Skills

Skills are modular, self-contained packages that extend the agent's capabilities by providing specialized knowledge, workflows, and tools. Think of them as "onboarding guides" for specific domains or tasks—they transform a general-purpose agent into a specialized agent equipped with procedural knowledge that no model can fully possess.

### What Skills Provide

1. **Specialized workflows** - Multi-step procedures for specific domains
2. **Tool integrations** - Instructions for working with specific file formats or APIs
3. **Domain expertise** - Company-specific knowledge, schemas, business logic
4. **Bundled resources** - Scripts, references, and assets for complex and repetitive tasks

### Key Benefits

- **Self-documenting**: A skill author or user can read a `SKILL.md` file and understand what it does, making skills easy to audit and improve
- **Interoperable**: Skills work across any agent that implements the [Agent Skills specification](https://agentskills.io/specification)
- **Extensible**: Skills can range in complexity from simple text instructions to bundled scripts, templates, and reference materials
- **Shareable**: Skills are portable and can be easily shared between projects and developers

## How Skills Work in Kilo Code

Skills can be:

- **Generic** - Available in all modes
- **Mode-specific** - Only loaded when using a particular mode (e.g., `code`, `architect`)

The workflow is:

1. **Discovery**: Skills are scanned from designated directories when Kilo Code initializes. Only the metadata (name, description, and file path) is read at this stage—not the full instructions.
2. **Prompt inclusion**: When a mode is active, the metadata for relevant skills is included in the system prompt. The agent sees a list of available skills with their descriptions.
3. **On-demand loading**: When the agent determines that a task matches a skill's description, it reads the full `SKILL.md` file into context and follows the instructions.

### How the Agent Decides to Use a Skill

The agent (LLM) decides whether to use a skill based on the skill's `description` field. There's no keyword matching or semantic search—the agent evaluates your request against all available skill descriptions and determines if one "clearly and unambiguously applies."

This means:
- **Description wording matters**: Write descriptions that match how users phrase requests
- **Explicit invocation always works**: Saying "use the api-design skill" will trigger it since the agent sees the skill name
- **Vague descriptions lead to uncertain matching**: Be specific about when the skill should be used

## Anatomy of a Skill

Every skill consists of a required SKILL.md file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Bash/etc.)
    ├── references/       - Documentation to load into context as needed
    └── assets/           - Files used in output (templates, icons, fonts, etc.)
```

### SKILL.md (required)

**Metadata Quality:** The `name` and `description` in YAML frontmatter determine when the agent will use the skill. Be specific about what the skill does and when to use it. Use the third-person (e.g. "This skill should be used when..." instead of "Use this skill when...").

### Bundled Resources (optional)

#### Scripts (`scripts/`)

Executable code (Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Benefits**: Token efficient, deterministic, may be executed without loading into context
- **Note**: Scripts may still need to be read by the agent for patching or environment-specific adjustments

#### References (`references/`)

Documentation and reference material intended to be loaded as needed into context to inform the agent's process and thinking.

- **When to include**: For documentation that the agent should reference while working
- **Examples**: `references/api_docs.md` for API specifications, `references/schema.md` for database schemas
- **Use cases**: Database schemas, API documentation, domain knowledge, company policies, detailed workflow guides
- **Benefits**: Keeps SKILL.md lean, loaded only when the agent determines it's needed
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references files, not both

#### Assets (`assets/`)

Files not intended to be loaded into context, but rather used within the output the agent produces.

- **When to include**: When the skill needs files that will be used in the final output
- **Examples**: `assets/logo.png` for brand assets, `assets/template.html` for HTML boilerplate
- **Use cases**: Templates, images, icons, boilerplate code, fonts, sample documents that get copied or modified
- **Benefits**: Separates output resources from documentation, enables the agent to use files without loading them into context

## Skill Locations

Skills are loaded from multiple locations, allowing both personal skills and project-specific instructions.

### Global Skills (User-Level)

Global skills are located in the `.kilocode` directory within your Home directory.

- Mac and Linux: `~/.kilocode/skills/`
- Windows: `\Users\<yourUser>\.kilocode\`

```
~/.kilocode/
├── skills/                    # Generic skills (all modes)
│   ├── my-skill/
│   │   └── SKILL.md
│   └── another-skill/
│       └── SKILL.md
├── skills-code/              # Code mode only
│   └── refactoring/
│       └── SKILL.md
└── skills-architect/         # Architect mode only
    └── system-design/
        └── SKILL.md
```

### Project Skills (Workspace-Level)

Located in `.kilocode/skills/` within your project:

```
your-project/
└── .kilocode/
    ├── skills/               # Generic skills for this project
    │   └── project-conventions/
    │       └── SKILL.md
    └── skills-code/          # Code mode skills for this project
        └── linting-rules/
            └── SKILL.md
```

### Mode-Specific Skills

To create a skill that only appears in a specific mode:

```bash
# For Code mode only
mkdir -p ~/.kilocode/skills-code/typescript-patterns

# For Architect mode only
mkdir -p ~/.kilocode/skills-architect/microservices
```

The directory naming pattern is `skills-{mode-slug}` where `{mode-slug}` matches the mode's identifier (e.g., `code`, `architect`, `ask`, `debug`).

## Priority and Overrides

When multiple skills share the same name, Kilo Code uses these priority rules:

1. **Project skills override global skills** - A project skill with the same name takes precedence
2. **Mode-specific skills override generic skills** - A skill in `skills-code/` overrides the same skill in `skills/` when in Code mode

This allows you to:
- Define global skills for personal use
- Override them per-project when needed
- Customize behavior for specific modes

## Progressive Disclosure Design Principle

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words recommended)
3. **Bundled resources** - As needed by the agent (unlimited for scripts*)

*Scripts can be executed without reading into context window.

## SKILL.md Format Specification

The `SKILL.md` file must contain YAML frontmatter followed by Markdown content.

### Required Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Max 64 characters. Lowercase letters, numbers, and hyphens only. Must not start or end with a hyphen. |
| `description` | Yes | Max 1024 characters. Describes what the skill does and when to use it. |

### Optional Fields

| Field ||-------|----------| Required | Description |
-------------|
| `license` | No | License name (e.g., MIT, Apache-2.0) or reference to a bundled license file |
| `compatibility` | No | Environment requirements (intended product, system packages, network access, etc.) |
| `metadata` | No | Arbitrary key-value mapping for additional properties |
| `allowed-tools` | No | Space-delimited list of tools pre-approved to run |

### Name Matching Rule

In Kilo Code, the `name` field **must match** the parent directory name:

```
✅ Correct:
skills/
└── frontend-design/
    └── SKILL.md  # name: frontend-design

❌ Incorrect:
skills/
└── frontend-design/
    └── SKILL.md  # name: my-frontend-skill  (doesn't match!)
```

### Body Content

The Markdown body after the frontmatter contains the skill instructions. Recommended sections:

- Step-by-step instructions
- Examples of inputs and outputs
- Common edge cases

Note that the agent will load this entire file once it's decided to activate a skill. Consider splitting longer `SKILL.md` content into referenced files.

### Example Frontmatter

```yaml
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents.
license: Apache-2.0
metadata:
    author: example-org
    version: 1.0.0
allowed-tools: read_file write_to_file execute_command
---

# PDF Processing Skill

## When to use
Use this skill for working with PDF documents...

## Instructions
...
```

## When to use this skill

- Creating new skills from scratch to automate workflows.
- Refactoring existing "heavy" system prompts into modular skills.
- Setting up folder structure (scripts/, references/, assets/) for complex skills.
- Debugging skills that don't activate correctly.
- Understanding the Agent Skills specification.

## Design Principles (Your Constitution)

When developing skills, **must** follow these rules:

1. **Separate Logic (Deterministic vs. Agentic)**:
   - If a task requires precision (calculations, running tests, formatting), move it to a script in the `scripts/` folder.
   - If a task requires context interpretation or text generation, leave it to the LLM's discretion.

2. **Progressive Disclosure**:
   - The `SKILL.md` file should be compact (up to 500 lines).
   - Move deep documentation to `references/`, and templates to `assets/`.

3. **Constitution, not advice**:
   - Write instructions in imperative form ("Always do X", "Never change Y").
   - Clearly specify exit criteria from the task using the `attempt_completion` tool.

## Categories of Rules to Create

### 1. Code Style Rules
- Formatting and indentation
- Naming conventions
- Team style consistency
- Documentation standards

### 2. Security Rules
- Limiting access to confidential files
- Preventing reading of sensitive data
- Access control to directories and secrets

### 3. Project Structure Rules
- File and directory organization
- Architectural constraints
- Placement of various component types

### 4. Documentation Requirements
- Documentation formats and standards
- Required comments and annotations
- API documentation standards

### 5. Testing Patterns
- Test structure and organization
- Test naming conventions
- Code coverage requirements

### 6. API Usage Rules
- Standards for working with external APIs
- Library usage conventions
- Limitations on using certain APIs

### 7. Workflow Definitions
- Step-by-step algorithms for complex tasks
- Checkpoints and validation criteria between steps
- Required user interactions vs. autonomous actions

## Rule Creation Best Practices

### Structuring Principles

1. **Single Responsibility:** each rule file is responsible for one area
2. **Hierarchical Organization:** use clear header structure
3. **Specificity:** avoid overly general formulations
4. **Examples:** always include specific examples for complex rules

### Recommended File Structure

```
.kilocode/rules/
├── 00-general.md         # Core principles
├── 10-security.md        # Security & Secrets (High priority)
├── 20-project_structure.md  # Architecture
├── 30-naming.md          # Naming conventions
├── 40-formatting.md      # Code style/Prettier
├── 50-testing.md         # Testing requirements
└── 90-workflows.md       # Specific workflows
```

### Traceability Block

Use a compact single-line format at the very top of the file:

```
> **Meta:** v{Version} | {Date}
```

Or use an HTML comment if the information is strictly for developers:

```
<!-- Meta: v{Version} | {Date} -->
```

### Language Requirements

- **Imperative mood:** use "MUST", "SHOULD", "NEVER"
- **Clarity of formulations:** avoid ambiguity
- **Context:** provide sufficient context for understanding
- **Exceptions:** clearly describe special cases

## Step-by-step skill creation guide

### Step 1: Understanding the Skill with Concrete Examples

Skip this step only when the skill's usage patterns are already clearly understood.

To create an effective skill, clearly understand concrete examples of how the skill will be used. This understanding can come from either direct user examples or generated examples that are validated with user feedback.

For example, when building an image-editor skill, relevant questions include:

- "What functionality should the skill support? Editing, rotating, anything else?"
- "Can you give examples of how this skill would be used?"
- "What would a user say that should trigger this skill?"

To avoid overwhelming users, avoid asking too many questions in a single message. Start with the most important questions and follow up as needed.

Conclude this step when there is a clear sense of the functionality the skill should support.

### Step 2: Planning the Reusable Skill Contents

To turn concrete examples into an effective skill, analyze each example by:

1. Considering how to execute on the example from scratch
2. Identifying what scripts, references, and assets would be helpful when executing these workflows repeatedly

**Example analysis:**

| User Request | Resource Needed | Location |
|--------------|-----------------|----------|
| "Rotate this PDF" | Reusable rotation code | `scripts/rotate.sh` |
| "Build me a todo app" | HTML boilerplate | `assets/todo-template/` |
| "Query user data" | Schema documentation | `references/schema.md` |

To establish the skill's contents, analyze each concrete example to create a list of the reusable resources to include.

### Step 3: Structure initialization

Create a skill folder in `~/.kilocode/skills/` (globally) or `.kilocode/skills/` (in the project).

The structure should be as follows:
- `SKILL.md` (mandatory)
- `scripts/` (for executable code, if needed)
- `references/` (for long guides, if needed)
- `assets/` (for templates and output files, if needed)

### Step 4: Fill the Frontmatter

Required fields:
- **name**: Must match the folder name, lowercase letters and hyphens only.
- **description**: The most important field. Include keywords by which KiloCode will understand when to activate the skill.

Optional fields:
- **license**: License name (e.g., MIT, Apache-2.0)
- **compatibility**: Environment requirements (e.g., "KiloCode CLI v1.0+")
- **allowed-tools**: List of tools that the skill can use without additional confirmation
- **metadata**: Additional properties (author, version, category, etc.)

### Step 5: Writing instructions

Divide the Markdown body into sections:

1. **## About Skills** (optional) - Brief explanation of what the skill enables
2. **## When to use this skill** - List of triggers
3. **## Design Principles** (optional) - Core rules the agent must follow
4. **## Instructions** - Clear steps for task execution
5. **## Examples** - Examples of ideal execution (few-shot prompting)

### Step 6: Iterate

After testing the skill, users may request improvements. Often this happens right after using the skill, with fresh context of how the skill performed.

**Iteration workflow:**
1. Use the skill on real tasks
2. Notice struggles or inefficiencies
3. Identify how SKILL.md or bundled resources should be updated
4. Implement changes and test again

## Writing Style

Write the entire skill using **imperative/infinitive form** (verb-first instructions), not second person. Use objective, instructional language (e.g., "To accomplish X, do Y" rather than "You should do X" or "If you need to do X"). This maintains consistency and clarity for AI consumption.

To complete SKILL.md, answer the following questions:

1. What is the purpose of the skill, in a few sentences?
2. When should the skill be used?
3. In practice, how should the agent use the skill? All reusable skill contents should be referenced so that the agent knows how to use them.

## Examples

### Example of quality description (Frontmatter)

```yaml
description: Activate for code review to check compliance with OWASP security standards. Use when user asks "check code" or "find vulnerabilities".
```

### Example of complete frontmatter

```yaml
---
name: security-reviewer
description: Activate for security code review. Use when user asks to check code for vulnerabilities, security issues, or OWASP compliance.
license: MIT
compatibility: KiloCode CLI v1.0+
metadata:
  author: "Security Team"
  version: "1.0.0"
  category: security
allowed-tools: read_file search_files list_files
---
```

### Example of "Constitutional" rule

```markdown
## Design Principles

1. **Never skip validation**: If a script returned an error, don't try to ignore it. First fix all errors before suggesting a commit.

2. **Always check references**: Before implementing, check `references/` folder for existing patterns and schemas.

3. **Fail fast**: If prerequisites are missing, report immediately rather than attempting workarounds.
```

### Example of references usage in SKILL.md

```markdown
## Database Operations

For all database operations, refer to the schema documentation:

- Table schemas: `references/database-schema.md`
- Query patterns: `references/query-patterns.md`

To search for specific table information:
```bash
grep -n "table_name" references/database-schema.md
```
```

## Rule Creation Algorithm

### Step 1: Requirements Analysis
1. Determine the rule category (security, style, structure, etc.)
2. Determine the scope of application (global, project, mode-specific)
3. Determine the main requirements and constraints
4. Analyze possible exceptions

### Step 2: Structuring
1. Create a descriptive header
2. Write a brief purpose description
3. Structure main requirements into logical groups
4. Prepare specific code examples
5. Determine exceptions and edge cases

### Step 3: Rule Formulation
1. Use clear, unambiguous language
2. Apply imperative mood for directives
3. Include specific examples for complex cases
4. Balance between specificity and flexibility

### Step 4: Verification
1. Check Markdown syntax correctness
2. Ensure there are no contradictions with existing rules
3. Test the rule on specific examples
4. Evaluate readability and clarity for other developers

## Verification and Debugging

- To check activation, make a request and look in the terminal logs (flag `--print-logs`) for the `read_file` call for your `SKILL.md`.
- If the agent doesn't see the skill, reload KiloCode or the VS Code window.
- If the skill activates but doesn't follow instructions, check:
  1. Description clarity in frontmatter
  2. Imperative form usage in instructions
  3. Proper section structure

### Troubleshooting Common Issues

| Error | Cause | Solution |
|-------|-------|----------|
| "missing required 'name' field" | No `name` in frontmatter | Add `name: your-skill-name` |
| "name doesn't match directory" | Mismatch between frontmatter and folder name | Make `name` match exactly |
| Skill not appearing | Wrong directory structure | Verify path follows `skills/skill-name/SKILL.md` |

## Finding Skills

You can discover and install community-created skills through:

- **Kilo Marketplace** - Browse skills directly in the Kilo Code extension via the Marketplace tab, or explore the [Kilo Marketplace repository](https://github.com/Kilo-Org/kilo-marketplace) on GitHub
- **Agent Skills Specification** - The open specification that skills follow, enabling interoperability across different AI agents

## Contributing to the Marketplace

Have you created a skill that others might find useful? Share it with the community by contributing to the [Kilo Marketplace](https://github.com/Kilo-Org/kilo-marketplace)!

### How to Submit Your Skill

1. **Prepare your skill**: Ensure your skill directory contains a valid `SKILL.md` file with proper frontmatter
2. **Test thoroughly**: Verify your skill works correctly across different scenarios and modes
3. **Fork the marketplace repository**: Visit [github.com/Kilo-Org/kilo-marketplace](https://github.com/Kilo-Org/kilo-marketplace) and create a fork
4. **Add your skill**: Place your skill directory in the appropriate location following the repository's structure
5. **Submit a pull request**: Create a PR with a clear description of what your skill does and when it's useful

### Submission Guidelines

- Follow the [Agent Skills specification](https://agentskills.io/specification) for your `SKILL.md` file
- Include a clear `name` and `description` in the frontmatter
- Document any dependencies or requirements (scripts, external tools, etc.)
- If your skill includes bundled resources (scripts, templates), ensure they are well-documented
- Follow the contribution guidelines in the marketplace repository
