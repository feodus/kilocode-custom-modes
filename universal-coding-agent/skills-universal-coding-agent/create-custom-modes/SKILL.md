---
name: create-custom-modes
description: Helps create Custom Modes for KiloCode according to the Agent Skills specification
---

# Skill: Creating Custom Modes for KiloCode

## Description

This skill provides step-by-step instructions and templates for creating Custom Modes in KiloCode. It covers all aspects of creating custom modes, including file structure, configuration format, YAML/JSON syntax, and best practices.

## When to use

Use this skill when you need to:
- Create a new Custom Mode for KiloCode
- Update an existing Custom Mode
- Create a template for a new type of mode
- Ensure compliance with the Agent Skills specification
- Configure file access restrictions using regular expressions

## Custom Mode Creation Process

### 1. Structure preparation

Create a directory for the new mode according to the mode name:

```
.kilocode/skills-{mode-slug}/
```

Or for a global mode:
```
~/.kilocode/skills-{mode-slug}/
```

### 2. Creating the main YAML configuration file

Each custom mode must be defined in YAML format (preferred) or JSON format. The mode can be saved in:
- **Global modes**: `custom_modes.yaml` or `custom_modes.json` (in user config)
- **Project modes**: `.kilocodemodes` file in project root

### 3. Defining mode parameters

#### Required fields:
- `slug` - unique identifier for the mode (letters, numbers, and hyphens only)
- `name` - display name for the mode
- `description` - brief description of the mode's purpose
- `roleDefinition` - main role and expertise of the mode
- `groups` - list of allowed tool groups

#### Optional fields:
- `whenToUse` - guidance for automated decision-making
- `customInstructions` - specific behavioral guidelines

#### Example of minimal configuration file:

```yaml
customModes:
  - slug: my-web-developer
    name: 💻 Web Developer
    description: Mode for web development with limited file access
    roleDefinition: >-
      You are an expert in web development. 
      Your task is to assist in creating web applications.
    groups:
      - read
      - - edit
        - fileRegex: \.(js|ts|jsx|tsx|html|css|scss)$
          description: Web technology files only
      - command
```

### 4. Defining permissions and restrictions

#### Available tool groups:
- `read` - file reading
- `edit` - file editing
- `command` - command execution
- `browser` - browser usage
- `mcp` - access to other tools

#### Restrictions for the `edit` group:
- `fileRegex` - regular expression to limit file access
- `description` - description of the restriction

## YAML Configuration Format (Preferred)

YAML is the preferred format for defining custom modes due to:

- **Readability:** YAML's indentation-based structure is easier for humans to read and understand
- **Comments:** YAML allows for comments (lines starting with `#`), making it possible to annotate your mode definitions
- **Multi-line Strings:** YAML provides cleaner syntax for multi-line strings using `|` (literal block) or `>` (folded block)
- **Less Punctuation:** YAML generally requires less punctuation compared to JSON, reducing syntax errors
- **Editor Support:** Most modern code editors provide excellent syntax highlighting and validation for YAML files

### YAML Multi-line Strings

Use `>-` for folded block (single line breaks become spaces):
```yaml
roleDefinition: >-
    You are a test engineer with expertise in:
    - Writing comprehensive test suites
    - Test-driven development
```

Use `|-` for literal block (preserves newlines):
```yaml
customInstructions: |-
    When writing tests:
    - Use describe/it blocks
    - Include meaningful descriptions
```

## Understanding Regex in Custom Modes

Regular expressions (`fileRegex`) offer fine-grained control over file editing permissions.

### Important Rules for fileRegex

- **Escaping in YAML:** In unquoted or single-quoted YAML strings, a single backslash is usually sufficient for regex special characters (e.g., `\.md$`)
- **Escaping in JSON:** In JSON strings, backslashes (`\`) must be double-escaped (e.g., `\\.md$`)
- **Path Matching:** Patterns match against the full relative file path from your workspace root
- **Case Sensitivity:** Regex patterns are case-sensitive by default
- **Validation:** Invalid regex patterns are rejected with an "Invalid regular expression pattern" error message

### Common Pattern Examples

| Pattern (YAML) | JSON fileRegex | Matches | Doesn't Match |
|----------------|----------------|---------|---------------|
| `\.md$` | `"\\.md$"` | `readme.md`, `docs/guide.md` | `script.js`, `readme.md.bak` |
| `^src/.*` | `"^src/.*"` | `src/app.js`, `src/components/button.tsx` | `lib/utils.js` |
| `\.(css\|scss)$` | `"\\.(css\|scss)$"` | `styles.css`, `theme.scss` | `styles.less` |
| `docs/.*\.md$` | `"docs/.*\\.md$"` | `docs/guide.md` | `guide.md` |
| `^(?!.*(test\|spec))\.(js\|ts)$` | `"^(?!.*(test\|spec))\\.(js\|ts)$"` | `app.js`, `utils.ts` | `app.test.js` |

### Key Regex Building Blocks

- `\.`: Matches a literal dot (YAML: `\.`, JSON: `\\.`)
- `$`: Matches the end of the string
- `^`: Matches the beginning of the string
- `.*`: Matches any character (except newline) zero or more times
- `(a|b)`: Matches either "a" or "b"
- `(?!...)`: Negative lookahead

## YAML/JSON Property Details

### slug
- **Purpose:** A unique identifier for the mode
- **Format:** Must match the pattern `/^[a-zA-Z0-9-]+$/` (only letters, numbers, and hyphens)
- **Usage:** Used internally and in file/directory names for mode-specific rules

### name
- **Purpose:** The display name shown in the Kilo Code UI
- **Format:** Can include spaces and proper capitalization, emojis allowed

### description
- **Purpose:** A short, user-friendly summary displayed below the mode name in the mode selector UI
- **Format:** Keep this concise and focused on what the mode does for the user

### roleDefinition
- **Purpose:** Detailed description of the mode's role, expertise, and personality
- **Placement:** This text is placed at the beginning of the system prompt when the mode is active

### groups
- **Purpose:** Array/list defining which tool groups the mode can access and any file restrictions
- **Structure:**
  - Simple string for unrestricted access: `"edit"`
  - Tuple (two-element array) for restricted access: `["edit", { fileRegex: "pattern", description: "optional" }]`

### whenToUse (Optional)
- **Purpose:** Provides guidance for Kilo's automated decision-making, particularly for mode selection and task orchestration
- **Usage:** Used by Kilo for automated decisions and not displayed in the mode selector UI

### customInstructions (Optional)
- **Purpose:** A string containing additional behavioral guidelines for the mode
- **Placement:** This text is added near the end of the system prompt

## Examples of different mode types

### 1. Web Developer Mode
```yaml
customModes:
  - slug: web-developer
    name: 💻 Web Developer
    description: Mode for web development with frontend focus
    roleDefinition: >-
      You are an expert in web development. 
      You specialize in creating modern web applications
      using React, Vue, Angular, and other frontend frameworks.
    whenToUse: >-
      Use this mode for tasks related to frontend development,
      creating user interfaces and web design.
    customInstructions: |-
      When creating web components:
      - Follow modern HTML5 and CSS3 standards
      - Use semantic tags
      - Ensure accessibility
      - Apply responsive design
    groups:
      - read
      - - edit
        - fileRegex: \.(js|ts|jsx|tsx|html|css|scss|vue|svelte)$
          description: Web technology files only
      - command
```

### 2. API Developer Mode
```yaml
customModes:
  - slug: api-developer
    name: 🌐 API Developer
    description: Mode for API development with backend focus
    roleDefinition: >-
      You are an expert in API development.
      You specialize in creating REST and GraphQL APIs
      using various backend technologies.
    whenToUse: >-
      Use this mode for tasks related to backend development,
      creating APIs and integrations.
    customInstructions: |-
      When creating APIs:
      - Follow REST principles
      - Ensure proper error handling
      - Document endpoints
      - Use authentication and authorization
    groups:
      - read
      - - edit
        - fileRegex: \.(js|ts|py|java|go|php|rb|cs)$
          description: Backend technology files only
      - command
```

### 3. Documentation Writer Mode
```yaml
customModes:
  - slug: docs-writer
    name: 📝 Documentation Writer
    description: Mode for writing and editing documentation
    roleDefinition: >-
      You are a technical writer specializing in creating 
      clear and comprehensive documentation for developers.
    whenToUse: >-
      Use this mode for tasks related to writing documentation,
      guides, and technical descriptions.
    customInstructions: |-
      When writing documentation:
      - Use clear and concise language
      - Include practical examples
      - Follow technical writing principles
      - Ensure structured presentation of information
    groups:
      - read
      - - edit
        - fileRegex: \.(md|mdx|txt|rst)$
          description: Documentation files only
      - browser
```

### 4. Security Review Mode (Read-only)
```yaml
customModes:
  - slug: security-review
    name: 🔒 Security Reviewer
    description: Read-only security analysis and vulnerability assessment
    roleDefinition: >-
      You are a security specialist reviewing code for vulnerabilities.
    whenToUse: Use for security reviews and vulnerability assessments
    customInstructions: |-
      Focus on:
      - Input validation issues
      - Authentication and authorization flaws
      - Data exposure risks
      - Injection vulnerabilities
    groups:
      - read
      - browser
```

## Custom Rules Integration

When creating custom modes, you can also create mode-specific rules for additional behavioral guidance.

### Rule Structure

Custom rules can be written in plain text, but Markdown format is recommended:

- Use Markdown headers (`#`, `##`, etc.) to define rule categories
- Use lists (`-`, `*`) to enumerate specific items or constraints
- Use code blocks for code examples

### Rule File Locations

- **Project rules:** `.kilocode/rules/` directory
- **Mode-specific rules:** `.kilocode/rules-{mode-slug}/` directory
- **Global rules:** `~/.kilocode/rules/` directory

### Priority Order

1. Mode-specific rules (highest priority)
2. Project rules
3. Global rules (lowest priority)

### Example: Security Rule

```markdown
# Restricted File Access
Files containing confidential information that CANNOT be accessed or read

## List of Confidential Files
- *.env and .env.*
- config/database.yml
- secrets/*.key
- *.pem files
- supersecrets.txt

## Behavior Requirements
- When requested to read these files, politely refuse
- Explain that the files contain confidential information
- Suggest using environment variables or secure configuration methods
- NEVER show the contents of restricted files even partially
```

## Prompt Engineering Best Practices

When writing custom instructions for modes, follow these principles:

### Be Clear and Specific
- **Bad:** "Fix the code."
- **Good:** "Fix the bug in the `calculateTotal` function that causes it to return incorrect results."

### Provide Context
Use context mentions to refer to specific files or problems:
- **Good:** `@/src/utils.ts` Refactor the `calculateTotal` function to use async/await.

### Break Down Tasks
Divide complex tasks into smaller, well-defined steps.

### Give Examples
If you have a specific coding style or pattern in mind, provide examples.

### Use "Think-then-Do" Process
1. **Analyze:** Ask to analyze the current code, identify problems, or plan the approach.
2. **Plan:** Have outline the steps to complete the task.
3. **Execute:** Instruct to implement the plan, one step at a time.
4. **Review:** Carefully review the results of each step before proceeding.

## Versioning Policy

When modifying existing modes, follow the versioning policy:

- The filename MUST include the version number (e.g., `mode-name-v1.1.yaml`)
- The title/description within the file MUST indicate the version
- The traceability block MUST contain updated Version information
- The original file SHOULD remain unchanged to maintain historical record

Example:
```yaml
customModes:
  - slug: my-mode
    name: 💻 My Mode
    description: A powerful mode - Updated v1.1, 07-03-2026
    # ... rest of configuration
```

## Configuration Precedence

Mode configurations are applied in this order:

1. **Project-level mode configurations** (from `.kilocodemodes`)
2. **Global mode configurations** (from `custom_modes.yaml`, then `custom_modes.json`)
3. **Default mode configurations**

**Important:** When modes with the same slug exist in both `.kilocodemodes` and global settings, the `.kilocodemodes` version completely overrides the global one for ALL properties.

## Overriding Default Modes

You can override Kilo Code's built-in modes (like Code, Debug, Ask, Architect, Orchestrator) by creating a custom mode with the same slug:

```yaml
customModes:
  - slug: code
    name: 💻 Code (Project-Specific)
    roleDefinition: You are a software engineer with project-specific constraints.
    whenToUse: This project-specific code mode is for Python tasks.
    customInstructions: Adhere to PEP8 and use type hints.
    groups:
      - read
      - - edit
        - fileRegex: \.py$
          description: Python files only
      - command
```

## Tips for Working with YAML

- **Indentation is Key:** YAML uses indentation (spaces, not tabs) to define structure
- **Colons for Key-Value Pairs:** Keys must be followed by a colon and a space (e.g., `slug: my-mode`)
- **Hyphens for List Items:** List items start with a hyphen and a space (e.g., `- read`)
- **Validate Your YAML:** Use online YAML validators or your editor's built-in validation
- **Use Comments:** Add comments with `#` to document your configuration

## Troubleshooting

### Common Issues

- **Mode not appearing:** After creating or importing a mode, reload the VS Code window
- **Invalid regex patterns:** Test patterns using online regex testers before applying them
- **Precedence confusion:** Remember that project modes completely override global modes with the same slug
- **YAML syntax errors:** Use proper indentation (spaces, not tabs) and validate your YAML
- **FileRestrictionError:** When a mode attempts to edit a file that doesn't match its `fileRegex` pattern

## Checks and recommendations

### Before creating a mode:
1. Define the main purpose and functionality of the mode
2. Define file access restrictions
3. Ensure the mode name is unique
4. Check that regular expressions are correct

### After creating a mode:
1. Test the mode with various tasks
2. Verify that restrictions work correctly
3. Ensure the mode description is clear
4. Check that the role and instructions are clearly defined

## Best Practices

1. **Clear naming:** use clear and descriptive names for modes
2. **Security restrictions:** always limit file access with fileRegex
3. **Clear instructions:** provide clear instructions and descriptions
4. **Testing:** test each mode before using
5. **Documentation:** document the purpose and features of each mode
6. **Versioning:** follow versioning policy for modifications
7. **Imperative mood:** use "MUST", "SHOULD", "NEVER" for directives
8. **Single Responsibility:** each mode should focus on one area

## Templates for common tasks

### Safe mode template (read-only)
```yaml
customModes:
  - slug: safe-reviewer
    name: 🔍 Safe Reviewer
    description: Read-only mode for code analysis
    roleDefinition: >-
      You are an expert in code analysis. 
      Your task is to review and analyze code without the ability to change it.
    groups:
      - read
      - browser
```

### Language-specific template
```yaml
customModes:
  - slug: python-developer
    name: 🐍 Python Developer
    description: Mode for Python development
    roleDefinition: >-
      You are an expert in Python development.
      You specialize in creating server applications, scripts, and libraries.
    groups:
      - read
      - - edit
        - fileRegex: \.(py)$
          description: Python files only
      - command
```

This skill enables creating effective and secure Custom Modes for various tasks in KiloCode.
