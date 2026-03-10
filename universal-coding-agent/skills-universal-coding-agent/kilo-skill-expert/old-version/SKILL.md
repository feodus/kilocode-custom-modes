---
name: kilo-skill-expert
description: Use this skill when you need to create, edit, or debug skills for KiloCode. The skill helps structure SKILL.md, implement progressive disclosure principles, and separate deterministic tasks from cognitive ones.
license: MIT
compatibility: KiloCode CLI v1.0+, VS Code Extension
metadata:
  author: "Expert Developer"
  version: "1.0.0"
allowed-tools: read_file search_files list_files list_code_definition_names apply_diff write_to_file execute_command use_mcp_tool access_mcp_resource attempt_completion
---

# KiloCode Skill Development Expert

## When to use this skill
- Creating new skills from scratch to automate workflows.
- Refactoring existing "heavy" system prompts into modular skills.
- Setting up folder structure (scripts/, references/, assets/) for complex skills.
- Integrating deterministic bash/python scripts into agent logic.

## Design Principles (Your Constitution)
When developing skills you **must** follow these rules:

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

### Step 1: Structure initialization
Create a skill folder in `~/.kilocode/skills/` (globally) or `.kilocode/skills/` (in the project).
The structure should be as follows:
- `SKILL.md` (mandatory).
- `scripts/` (for executable code).
- `references/` (for long guides).

### Step 2: Fill the Frontmatter
- **name**: Must match the folder name, lowercase letters and hyphens only.
- **description**: The most important field. Include keywords by which KiloCode will understand when to activate the skill.
- **allowed-tools**: List of tools that the skill can use without additional confirmation (if configured).

### Step 3: Writing instructions
Divide the Markdown body into sections:
- **## When to use this skill**: List of triggers.
- **## Instructions**: Clear steps for task execution.
- **## Examples**: Examples of ideal execution (few-shot prompting).

## Examples

### Example of quality description (Frontmatter)
```yaml
description: Activate for code review to check compliance with OWASP security standards. Use when user asks "check code" or "find vulnerabilities".
```

### Example of "Constitutional" rule
- "If the script `scripts/lint.sh` returned an error, don't try to ignore it. First fix all linter errors before suggesting a commit".

## Verification and debugging
- To check activation, make a request and look in the terminal logs (flag `--print-logs`) for the `read_file` call for your `SKILL.md`.
- If the agent doesn't see the skill, reload KiloCode or the VS Code window.
