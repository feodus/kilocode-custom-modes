---
name: kilo-skill-expert
description: Use this skill when you need to create, edit, or debug skills for KiloCode. The skill helps structure SKILL.md, implement progressive disclosure principles, and separate deterministic tasks from cognitive ones.
license: MIT
compatibility: KiloCode CLI v1.0+, VS Code Extension
metadata:
  author: "feodus"
  version: "1.1.0"
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

## Progressive Disclosure Design Principle

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words recommended)
3. **Bundled resources** - As needed by the agent (unlimited for scripts*)

*Scripts can be executed without reading into context window.

## When to use this skill

- Creating new skills from scratch to automate workflows.
- Refactoring existing "heavy" system prompts into modular skills.
- Setting up folder structure (scripts/, references/, assets/) for complex skills.
- Debugging skills that don't activate correctly.

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

## Verification and debugging

- To check activation, make a request and look in the terminal logs (flag `--print-logs`) for the `read_file` call for your `SKILL.md`.
- If the agent doesn't see the skill, reload KiloCode or the VS Code window.
- If the skill activates but doesn't follow instructions, check:
  1. Description clarity in frontmatter
  2. Imperative form usage in instructions
  3. Proper section structure
