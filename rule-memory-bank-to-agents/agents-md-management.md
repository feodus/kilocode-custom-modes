---
title: "AGENTS.md Management Rule"
source: "Custom rule for automatic AGENTS.md management"
author:
published:
created: 2026-02-14
description: "Rule for automatic initialization and updates of AGENTS.md file"
tags:
  - "documentation"
  - "agents-md"
  - "auto-update"
---

> **Meta:** v1.2.0 | 15-02-2026

# AGENTS.md Automatic Management Rule

## Purpose

This rule defines the process of automatic management of the AGENTS.md file, similar to working with Memory Bank. The rule ensures maintaining up-to-date documentation for AI agents through automatic initialization and updates of the AGENTS.md file for any changes in the project.

## When to Use

This rule is activated in the following cases:

- At first project launch or when AGENTS.md file is missing
- For any changes in the project (adding dependencies, changing configurations, updating structure)
- On explicit user request to update documentation (phrases: "update AGENTS.md", "update agents", "refresh agents-md")
- When starting a new task, if AGENTS.md is missing or outdated
- When detecting significant changes in the git repository after the last AGENTS.md update
- When adding new Skills to Universal Coding Agent

## Main Functions

### 1. Primary Initialization of AGENTS.md

When the AGENTS.md file is missing or at first project launch, create it with the following structure:

#### Required Sections

1. **Metadata (Header)**
   - Last update date
   - Git branch
   - Commit hash
   - Document version

2. **Project Overview**
   - Project name
   - Detailed description of purpose
   - Problem statement
   - Proposed solution
   - Main functionality
   - Target audience

3. **Architecture**
   - Project structure (directory tree with explanations)
   - Main components and their purpose
   - File access control
   - Integration points

4. **Tech Stack**
   - Main technologies and versions
   - Development tools
   - Supported languages and frameworks
   - Development environment

5. **Guidelines**
   - Coding style
   - Documentation standards
   - Testing requirements
   - Security rules

6. **Workflows**
   - Main workflows
   - Commit instructions
   - Deployment processes

7. **Common Tasks**
   - Frequently performed tasks
   - Step-by-step instructions

8. **Troubleshooting**
   - Known issues
   - Solutions

9. **Contributing**
   - Process for making changes
   - Commit requirements
   - Pull Request requirements

10. **Changelog**
    - Change history

11. **Resources**
    - Links to documentation
    - External resources

#### Initialization Template

```markdown
# AGENTS.md — [Project Name]

> **Last Updated:** DD-MM-YYYY HH:MM:SS UTC+3 | Branch: master | Commit: HASH | Version: 1.0

> **Description:** [Brief project description for AI agents]

---

## Project Overview

### Project Name
[Full project name]

### Purpose
[Detailed description of project purpose]

### Problem Statement
[What problem the project solves]

### Solution
[How the project solves the problem]

### Main Functionality
- [Function 1]
- [Function 2]
- [Function N]

### Target Audience
- [Audience 1]
- [Audience 2]

---

## Vision

### Current Status
- [Project status]
- [Number of implemented functions]
- [Development activity]

### Roadmap
1. [Item 1]
2. [Item 2]
3. [Item N]

### Recent Changes
- [Change 1]
- [Change 2]

---

## Architecture

### Project Structure
```
[Directory tree with comments]
```

### Main Components

#### [Component 1]
**Location:** `path/to/component`

**Description:** [Component purpose]

**Key Features:**
- [Feature 1]
- [Feature 2]

#### [Component N]
[Similar structure]

### File Access Control
| Component | Allowed File Types |
|-----------|-------------------|
| [Module 1] | [.ext1, .ext2] |
| [Module N] | [.ext1, .ext2] |

---

## Tech Stack

### Core Technologies
- **[Technology 1]:** [Usage description]
- **[Technology 2]:** [Usage description]

### Development Tools
- [Tool 1]: [Purpose]
- [Tool 2]: [Purpose]

### Supported Languages and Frameworks
- [Language 1]: [Frameworks]
- [Language 2]: [Frameworks]

### Development Environment
- Operating System: [OS]
- IDE: [IDE]
- Additional Requirements: [Requirements]

---

## Guidelines

### Coding Style
- [Rule 1]
- [Rule 2]

### Documentation
- [Requirement 1]
- [Requirement 2]

### Testing
- [Requirement 1]
- [Requirement 2]

### Security
- [Rule 1]
- [Rule 2]

---

## Workflows

### [Workflow 1]
1. [Step 1]
2. [Step 2]
3. [Step N]

### [Workflow N]
[Similar structure]

---

## Common Tasks

### [Task 1]
**When to Use:** [Description]

**Files to Modify:**
- `path/to/file1` - [Description of changes]
- `path/to/file2` - [Description of changes]

**Steps:**
1. [Step 1]
2. [Step 2]
3. [Step N]

**Important notes:**
- [Note 1]
- [Note 2]

---

## Troubleshooting

### Problem: [Problem Description]
**Cause:** [Cause]

**Solution:**
- [Step 1]
- [Step 2]

---

## Contributing

### Process for Making Changes
1. [Step 1]
2. [Step 2]
3. [Step N]

### Commit Requirements
- [Type]: [Description]
- [Type]: [Description]

### Pull Request Requirements
- [Requirement 1]
- [Requirement 2]

---

## Changelog

### v1.0.0 (DD-MM-YYYY)
- Initial version of AGENTS.md
- [Description of changes]

---

## Resources
- [Link 1]
- [Link 2]

---

*Last Updated: DD-MM-YYYY HH:MM:SS UTC+3*
```

### 2. Automatic Change Tracking

The rule should automatically track the following types of changes:

#### Types of Tracked Changes

1. **Adding New Dependencies**
   - Changes in `package.json`, `requirements.txt`, `pom.xml`, `go.mod`, etc.
   - Need to update Tech Stack section

2. **Changing Configurations**
   - Changes in configuration files (.yml, .json, .toml, etc.)
   - Need to update corresponding Architecture sections

3. **Updating Project Structure**
   - Adding/removing directories and files
   - Need to update Architecture → Project Structure section

4. **Adding New Components**
   - New modules, services, libraries
   - Need to add description to Main Components section

5. **API Changes**
   - New endpoints
   - Contract changes
   - Need to update API section (if applicable)

6. **Technology Updates**
   - Changes in language, framework, library versions
   - Need to update Tech Stack section

#### Change Detection Process

1. **Git-based Tracking:**
   - Get list of commits after last AGENTS.md update
   - Identify files changed in each commit
   - Map changes to corresponding AGENTS.md sections

2. **File System Analysis:**
   - Check for new directories
   - Detect new configuration files
   - Track changes in dependencies

3. **Change Classification:**
   - Major: architecture changes, adding new components
   - Minor: configuration updates, parameter changes
   - Patch: fixes, documentation updates

### 3. Update Format

When updating AGENTS.md, follow these requirements:

#### Accuracy Requirements

- Use exact versions of all technologies
- Specify exact paths to files and directories
- Provide specific examples of commands and scripts

#### Completeness Requirements

- Include all necessary sections
- Provide comprehensive explanations for each component
- Ensure understanding of current project state by new agents

#### Structure Requirements

- Follow header hierarchy
- Use tables for structured data
- Apply Markdown formatting for code and commands
- Include metadata with date and commit

#### Consistency Requirements

- Maintain uniform formatting style
- Use consistent terminology
- Update all related sections when making changes

### 4. Section Priorities

The most important sections for coding agents (in priority order):

1. **Exact Technology Versions**
   - All programming languages with versions
   - All frameworks and libraries with versions
   - Development tools with versions

2. **Project Structure**
   - Complete directory tree
   - Purpose of each directory
   - Key files in each directory

3. **Configuration Files**
   - Main configurations
   - Environment parameters
   - Linter and formatter settings

4. **Installation and Launch Instructions**
   - Environment requirements
   - Dependency installation commands
   - Launch commands

5. **Available Commands and Scripts**
   - List of npm/yarn/pip scripts
   - Build commands
   - Test commands

6. **Architectural Decisions**
   - Patterns used
   - Design principles
   - Constraints and conventions

### 5. Operation Mode

The rule works in the following modes:

#### Background Mode

- Automatic change tracking for each task
- Relevance check at start of new task
- Update when significant changes are detected

#### Active Mode

- Explicit user request for update
- Forced update of all sections
- Complete documentation restructuring

#### Initialization Mode

- Creating AGENTS.md from scratch
- Analyzing project structure
- Filling all sections

## Execution Process

### At Start of New Task

1. Check for AGENTS.md file in project root
2. If file is missing → create (perform initialization)
3. If file exists:
   - Check last update date
   - Get information about recent commits
   - Determine if there are changes after last update
   - If changes exist → update corresponding sections

### On Explicit Update Request

1. Perform full project analysis
2. Identify all changes since last update
3. Update all affected sections
4. Update metadata (date, commit)
5. Check reference integrity

### On Detection of Significant Changes

1. Analyze type of changes
2. Identify affected sections
3. Perform targeted update
4. Update metadata

## Metadata

Each AGENTS.md file must contain metadata in the following format:

```markdown
> **Last Updated:** DD-MM-YYYY HH:MM:SS UTC+3 | Branch: master | Commit: HASH | Version: X.X
```

Metadata update rules:
- Update on any content change
- Use current date and time
- Specify current git branch
- Specify last commit hash
- Increment version on significant changes

## Change Classification for AGENTS.md

### Major Changes (require full update)

- Project architecture change
- Adding a new main component
- Technology stack change
- Significant project structure change

### Minor Changes (require partial update)

- Adding a new dependency
- Configuration change
- Adding a new API endpoint
- Technology version update

### Patch Changes (minimal update)

- Fixing errors in documentation
- Adding examples
- Updating links
- Minor clarifications

## Automation

The following can be used for process automation:

1. **Git hooks:**
   - pre-commit: check AGENTS.md relevance
   - post-commit: automatic update when significant changes exist

2. **Scripts:**
   - check-agents-freshness.sh: check relevance
   - update-agents.sh: update documentation

3. **CI/CD:**
   - Relevance check in pipeline
   - Automatic PRs with updates

## Important Notes

1. AGENTS.md must be self-sufficient for understanding the project by a new agent
2. Avoid references to external resources unless absolutely necessary
3. Update documentation in parallel with code changes
4. Maintain balance between completeness and readability
5. Use examples for complex concepts
6. Document non-obvious decisions and patterns

## Integration with AGENTS.md

After migrating from Memory Bank to AGENTS.md:

- AGENTS.md is the main entry point for AI agents
- Memory Bank backup is saved in `.kilocode/rules/memory-bank-backup.zip` for reference purposes
- When initializing AGENTS.md, use information from previous Memory Bank sections
- When updating AGENTS.md, follow change classification (Major/Minor/Patch)

## Quality Check

After each AGENTS.md update, check:

- [ ] All required sections are present
- [ ] Metadata is current
- [ ] Links are valid
- [ ] Code examples are correct
- [ ] Structure matches template
- [ ] Information is consistent
- [ ] No spelling errors
