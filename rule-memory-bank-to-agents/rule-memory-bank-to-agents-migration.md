---
title: "Memory Bank to AGENTS.md Migration Rule"
source: "Consolidated rule for migration and management"
author:
published:
created: 2026-02-15
description: "Comprehensive rule for migrating from Memory Bank to AGENTS.md and managing AGENTS.md files"
tags:
  - "documentation"
  - "agents-md"
  - "migration"
  - "memory-bank"
---

> **Meta:** v2.0.0 | 15-02-2026

# Memory Bank to AGENTS.md Migration and Management Rule

## Purpose

This rule defines the comprehensive process for migrating from Memory Bank documentation system to a unified AGENTS.md file, managing AGENTS.md files, and understanding the Agent Skills specification. The rule ensures consistent, systematic migration while preserving all valuable information and providing guidance for ongoing maintenance.

## When to Use

This rule should be activated when:
- User requests "migrate to AGENTS.md"
- User requests "convert memory bank to agents"
- User requests "unify documentation to AGENTS.md"
- Starting a new project and choosing documentation format
- Existing Memory Bank needs to be modernized
- User requests "update AGENTS.md" or "refresh agents-md"
- When significant changes occur in the project
- When adding new components, dependencies, or configurations
- When setting up or validating Agent Skills

---

## What is Memory Bank?

Memory Bank is a structured documentation system that includes a set of organized files:

```
memory-bank/
├── brief.md        # Brief project description
├── product.md      # Product description
├── context.md      # Current work context
├── architecture.md # System architecture
├── tech.md         # Technology stack
├── tasks.md        # Task templates
└── CHANGELOG.md    # Change history
```

### Advantages of Memory Bank
- Structured approach with clear separation of responsibilities
- Built-in metadata system (versions, dates, commit hashes)
- Clear information hierarchy
- Automated scripts for checking relevance

### Disadvantages of Memory Bank
- Large number of files to maintain
- Complexity in scaling for large teams
- Limited compatibility with other AI agents

---

## What is AGENTS.md?

AGENTS.md is an open format supported by the Agentic AI Foundation under the Linux Foundation. The file is placed in the repository root and is automatically read by many AI agents.

README.md files are for humans: quick starts, project descriptions, and contribution guidelines.

AGENTS.md complements this by containing the extra, sometimes detailed context coding agents need: build steps, tests, and conventions that might clutter a README or aren't relevant to human contributors.

### Why AGENTS.md?

- Give agents a clear, predictable place for instructions
- Keep READMEs concise and focused on human contributors
- Provide precise, agent-focused guidance that complements existing README and docs
- Standardized format that works across AI agent ecosystem

### Advantages of AGENTS.md
- Standardized format (used in 60k+ projects)
- Compatibility with multiple AI agents (OpenAI Codex, Cursor, Jules, Factory, Amp)
- Simplicity of maintenance (one file)
- Hierarchical structure (support for nested AGENTS.md in monorepo)

### Disadvantages of AGENTS.md
- Less structured compared to Memory Bank
- Requires manual organization of information

### Sample AGENTS.md Structure

```markdown
# AGENTS.md

## Dev environment tips
- Environment setup instructions
- Build and run commands
- Package management guidelines

## Testing instructions
- How to run tests
- Criteria for successful test completion
- Coverage requirements

## PR instructions
- Commit message format
- Pull Request review process
- Code quality requirements
```

### Compatibility with AI Agents

AGENTS.md works across a growing ecosystem of AI coding agents and tools:
- OpenAI Codex
- Cursor
- Jules (Google)
- Factory
- Amp
- And many others

[View 60k+ examples on GitHub](https://github.com/search?q=path%3AAGENTS.md+NOT+is%3Afork+NOT+is%3Aarchived&type=code)

---

## AGENTS.md Specification

### How to Use AGENTS.md

#### 1. Add AGENTS.md
Create an AGENTS.md file at the root of the repository. Most coding agents can even scaffold one for you if you ask.

#### 2. Add Extra Instructions
Commit messages or pull request guidelines, security gotchas, large datasets, deployment steps: anything you'd tell a new teammate belongs here too.

#### 3. Large Monorepo? Use Nested AGENTS.md Files
Place another AGENTS.md inside each package. Agents automatically read the nearest file in the directory tree, so the closest one takes precedence and every subproject can ship tailored instructions.

### AGENTS.md Location Priority

AGENTS.md is read from different locations based on project structure:

1. **Root**: `./AGENTS.md` - Main project instructions
2. **Package/Service**: `./packages/my-package/AGENTS.md` - Package-specific
3. **Rules directory**: `./.config/rules/AGENTS.md` - Tool-specific

### Hierarchical Structure for Monorepo

```
my-monorepo/
├── AGENTS.md              # General instructions
├── packages/
│   ├── frontend/
│   │   └── AGENTS.md      # Specific instructions
│   ├── backend/
│   │   └── AGENTS.md
│   └── shared/
│       └── AGENTS.md
└── services/
    └── service-a/
        └── AGENTS.md
```

Each AGENTS.md is read by the agent from the current directory up the tree.

### History and Stewardship

AGENTS.md emerged from collaborative efforts across the AI software development ecosystem, including OpenAI Codex, Amp, Jules from Google, Cursor, and Factory.

AGENTS.md is now stewarded by the [Agentic AI Foundation](https://aaif.io/) under the Linux Foundation.

---

## Agent Skills Specification

This section defines the Agent Skills format for extending AI agent capabilities with specialized knowledge and workflows.

### Directory Structure

A skill is a directory containing at minimum a `SKILL.md` file:

```
my-skill/
├── SKILL.md           # Required: instructions + metadata
├── scripts/           # Optional: executable code
├── references/        # Optional: documentation
└── assets/            # Optional: templates, resources
```

### SKILL.md Format

The `SKILL.md` file must contain YAML frontmatter followed by Markdown content:

```markdown
---
name: my-skill-name
description: A brief description of what this skill does and when to use it
license: Apache-2.0        # Optional
compatibility: "..."       # Optional
metadata:                  # Optional
  author: example-org
  version: 1.0.0
---

# Instructions

Your detailed instructions for the AI agent go here.
```

### Required Fields

#### name field
- Must be 1-64 characters
- May only contain unicode lowercase alphanumeric characters and hyphens (`a-z` and `-`)
- Must not start or end with `-`
- Must not contain consecutive hyphens (`--`)
- Must match the parent directory name

**Valid examples:** `my-skill`, `api-design`, `python-testing`
**Invalid examples:** `-my-skill`, `my-skill-`, `my--skill`, `MySkill`

#### description field
- Must be 1-1024 characters
- Should describe both what the skill does and when to use it
- Should include specific keywords that help agents identify relevant tasks

**Good example:** "Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF processing tasks."
**Poor example:** "PDF tool"

### Optional Fields

#### license field
- Specifies the license applied to the skill
- Keep it short (either the name of a license or the name of a bundled license file)

#### compatibility field
- Must be 1-500 characters if provided
- Should only be included if your skill has specific environment requirements
- Can indicate intended product, required system packages, network access needs

#### metadata field
- A map from string keys to string values
- Use to store additional properties not defined by the spec
- Make key names reasonably unique to avoid accidental conflicts

#### allowed-tools field
- A space-delimited list of tools that are pre-approved to run
- Experimental: support may vary between agent implementations

### Body Content

The Markdown body after the frontmatter contains the skill instructions. There are no format restrictions.

**Recommended sections:**
- Step-by-step instructions
- Examples of inputs and outputs
- Common edge cases

**Note:** The agent will load this entire file once it decides to activate a skill. Consider splitting longer content into referenced files.

### Optional Directories

#### scripts/
Contains executable code that agents can run. Scripts should:
- Be self-contained or clearly document dependencies
- Include helpful error messages
- Handle edge cases gracefully

Supported languages depend on the agent implementation. Common options include Python, Bash, and JavaScript.

#### references/
Contains additional documentation that agents can read when needed:
- `REFERENCE.md` - Detailed technical reference
- `FORMS.md` - Form templates or structured data formats
- Domain-specific files (`finance.md`, `legal.md`, etc.)

Keep individual reference files focused. Agents load these on demand, so smaller files mean less context usage.

#### assets/
Contains static resources:
- Templates (document templates, configuration templates)
- Images (diagrams, examples)
- Data files (lookup tables, schemas)

### Context Efficiency Recommendations

Skills should be structured for efficient use of context:

1. **Metadata** (~100 tokens): The `name` and `description` fields are loaded at startup for all skills
2. **Instructions** (< 5000 tokens recommended): The full `SKILL.md` body is loaded when the skill is activated
3. **Resources** (as needed): Files are loaded only when required

Keep your main `SKILL.md` under 500 lines. Move detailed reference material to separate files.

### File References

When referencing other files in your skill, use relative paths from the skill root:

```markdown
See [Reference Guide](./references/guide.md) for details.
```

Keep file references one level deep from `SKILL.md`. Avoid deeply nested reference chains.

### Validation

Use the [skills-ref](https://github.com/agentskills/agentskills/tree/main/skills-ref) reference library to validate your skills. This checks that your `SKILL.md` frontmatter is valid and follows all naming conventions.

---

## Migration Workflow

### Step 1: Analyze Current Memory Bank

Before migration, inventory the existing Memory Bank files:

1. Locate Memory Bank directory
2. List all files and their purposes:
   - `brief.md` - Project overview
   - `product.md` - Product description
   - `context.md` - Current work context
   - `architecture.md` - System architecture
   - `tech.md` - Technology stack
   - `tasks.md` - Task templates
   - `CHANGELOG.md` - Change history

3. Identify which files contain critical information to preserve

### Step 2: Create AGENTS.md Structure

Create AGENTS.md in project root with following sections:

```markdown
# AGENTS.md

> **Last Updated:** DD-MM-YYYY HH:MM:SS UTC+3 | Branch: master | Commit: HASH

## Project Overview
[From brief.md and product.md]

## Development Environment
[From tech.md - setup requirements]

## Architecture
[From architecture.md]

## Tech Stack
[From tech.md]

## Coding Standards
[From existing rules or project conventions]

## Testing
[Test requirements and commands]

## Build & Deployment
[CI/CD and deployment info]

## Common Tasks
[From tasks.md - useful workflows]

## Troubleshooting
[Known issues and solutions]

## Contributing
[PR guidelines and commit conventions]
```

### Step 3: Migrate Content

Map Memory Bank files to AGENTS.md sections:

| Memory Bank File | AGENTS.md Section |
|------------------|-------------------|
| brief.md | Project Overview |
| product.md | Project Overview |
| context.md | Project Overview (current focus) |
| architecture.md | Architecture |
| tech.md | Tech Stack, Development Environment |
| tasks.md | Common Tasks |
| CHANGELOG.md | Reference (keep separate or summarize) |

### Step 4: Preserve Metadata

Add tracking metadata to AGENTS.md:

```markdown
> **Last Updated:** 15-02-2026 15:44:00 UTC+3 | Branch: master | Commit: abc123f
```

Update this header with each significant change.

### Step 5: Handle Optional Components

For complex projects, consider:

1. **Nested AGENTS.md**: Add subdirectory-specific AGENTS.md files
2. **Keep Memory Bank**: Optionally preserve for detailed reference
3. **Separate CHANGELOG**: Keep CHANGELOG.md for detailed change history

---

## AGENTS.md Management

### Content Guidelines

#### Project Overview Section
Must include:
- What the project is
- Main purpose and goals
- Key technologies or features
- Current status

#### Development Environment Section
Must include:
- Required tools and dependencies
- Setup commands
- How to run in development mode

#### Architecture Section
Must include:
- High-level system structure
- Key components and their relationships
- Integration points

#### Tech Stack Section
Must include:
- Programming languages
- Frameworks and libraries
- Build tools
- Key dependencies

#### Common Tasks Section
Must include:
- Frequently performed operations
- Step-by-step workflows
- Example commands

### Automatic Change Tracking

The system should automatically track the following types of changes:

#### Types of Tracked Changes

1. **Adding new dependencies**
   - Changes in `package.json`, `requirements.txt`, `pom.xml`, `go.mod`, etc.
   - Update Tech Stack section

2. **Configuration changes**
   - Changes in configuration files (.yml, .json, .toml, etc.)
   - Update corresponding Architecture sections

3. **Project structure updates**
   - Adding/removing directories and files
   - Update Architecture → Project Structure

4. **Adding new components**
   - New modules, services, libraries
   - Add description to Key Components section

5. **API changes**
   - New endpoints
   - Contract changes
   - Update API section (if applicable)

6. **Technology updates**
   - Language, framework, library version changes
   - Update Tech Stack section

### Change Detection Process

1. **Git-based tracking:**
   - Get list of commits after last AGENTS.md update
   - Identify files changed in each commit
   - Match changes to corresponding AGENTS.md sections

2. **File system analysis:**
   - Check for new directories
   - Detect new configuration files
   - Track dependency changes

3. **Change classification:**
   - Major: architecture changes, new components
   - Minor: configuration updates, parameter changes
   - Patch: fixes, documentation updates

### Change Classification for AGENTS.md

#### Major changes (require full update)
- Project architecture change
- Adding a new main component
- Technology stack change
- Significant project structure change

#### Minor changes (require partial update)
- Adding a new dependency
- Configuration change
- Adding a new API endpoint
- Technology version update

#### Patch changes (minimal update)
- Documentation error fixes
- Adding examples
- Updating links
- Minor clarifications

---

## Hybrid Approach

For maximum efficiency, it is recommended to use a **hybrid approach**:

1. **AGENTS.md** — main entry point for AI agent
2. **Memory Bank** — detailed documentation (optional)
3. **Additional files** — specific documentation

### Example of Hybrid Structure

```
project-root/
├── AGENTS.md              # Main instructions for agent
├── .config/
│   └── rules/
│       ├── memory-bank/   # (optional) Detailed documentation
│       │   ├── architecture.md
│       │   ├── tech.md
│       │   └── tasks.md
│       └── mode-specific/ # Mode-specific rules
├── workflows/             # Workflows
└── docs/                  # Additional documentation
```

---

## Practical Recommendations

### 1. Start Small

Don't try to transfer all documentation at once. Start with:

1. Brief project overview
2. Environment setup instructions
3. Basic development commands

### 2. Maintain Relevance

- Update AGENTS.md with every significant change
- Use git blame to track changes
- Add a reminder to the code review process

### 3. Test with Agent

After migration, verify that the agent correctly uses the information:

- Ask the agent to perform a typical task
- Check what information it uses
- Add missing sections

### 4. Document the Non-obvious

AGENTS.md is best suited for:

- "How to do X"
- "Why we do Y this way"
- "Known issues and solutions"

### 5. Use Examples

Include specific examples in each section:

```markdown
## Testing

Run all tests:
\`\`\`bash
npm test
\`\`\`

Run tests for a specific package:
\`\`\`bash
npm run test -- --filter=package-name
\`\`\`

Criteria for successful completion:
- 100% unit tests pass
- ≥80% integration tests pass
- 0 critical linter warnings
```

---

## Verification Checklist

After migration, verify:

- [ ] AGENTS.md exists in project root
- [ ] All critical information from Memory Bank preserved
- [ ] Metadata header added with date and commit
- [ ] Sections are clearly organized
- [ ] Agent can find and read AGENTS.md
- [ ] Key workflows documented in Common Tasks
- [ ] All technical specifications are accurate
- [ ] Links to external resources are valid
- [ ] Code examples are correct and runnable

---

## Rollback Procedure

If migration needs to be reverted:

1. Keep Memory Bank directory intact (do not delete)
2. Move AGENTS.md to backup location
3. Restore previous documentation structure
4. Verify agent can access previous documentation

---

## Maintenance

After initial migration:

1. Update AGENTS.md with each significant project change
2. Review and update metadata header periodically
3. Add new common tasks as they are identified
4. Keep sections current with project evolution
5. Validate Agent Skills when adding or modifying

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Agent not reading AGENTS.md | Wrong location | Place in project root |
| Invalid skill frontmatter | Missing required field | Add `name` and `description` |
| Skill name mismatch | Name doesn't match directory | Make `name` match directory name exactly |
| Skill not appearing | Wrong directory structure | Verify path follows `skills/skill-name/SKILL.md` |
| Outdated information | Not updated after changes | Update AGENTS.md with each significant change |
| Broken links | Moved or deleted files | Verify all links after file operations |

### Debugging Steps

1. Check the output panel for agent-specific errors
2. Verify frontmatter has required fields
3. Reload IDE to pick up new skills or AGENTS.md changes
4. Check file location matches expected structure
5. Validate YAML syntax in frontmatter

---

## References

### Official Specifications
- [AGENTS.md Specification](https://agents.md/)
- [Agent Skills Specification](https://agentskills.io/specification)
- [Agentic AI Foundation](https://aaif.io/)

### Examples and Resources
- [AGENTS.md Examples on GitHub](https://github.com/search?q=path%3AAGENTS.md+NOT+is%3Afork+NOT+is%3Aarchived&type=code)
- [Agent Skills Reference Library](https://github.com/agentskills/agentskills/tree/main/skills-ref)
- [What are Skills?](https://agentskills.io/what-are-skills)
- [Integrate Skills](https://agentskills.io/integrate-skills)

### Related Documentation
- Custom Modes Documentation
- Custom Rules Documentation
- Custom Instructions Documentation

---

*This consolidated rule provides comprehensive guidance for migrating from Memory Bank to AGENTS.md and managing AI agent documentation effectively.*
