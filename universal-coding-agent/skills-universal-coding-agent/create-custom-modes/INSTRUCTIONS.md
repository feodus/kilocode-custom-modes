# Instructions for using the "Creating Custom Modes" skill

## Overview
This skill provides a complete set of tools and templates for creating Custom Modes in KiloCode. It includes all necessary components for effective creation, configuration, and testing of custom modes.

## Skill Structure

### Main components:
- `SKILL.md` - main skill file with instructions
- `templates/` - directory with templates for various mode types
- `INSTRUCTIONS.md` - this file with usage instructions
- `examples/` - directory with examples of ready configurations (if available)

## How to use the skill

### 1. Usage through KiloCode
When you receive a request to create a Custom Mode:
1. KiloCode will automatically recognize that the task matches this skill
2. The system will load instructions from `SKILL.md`
3. Follow the instructions provided in the main skill file

### 2. Developer guide
If you develop a Custom Mode manually:
1. Study `SKILL.md` to understand the overall process
2. Select an appropriate template from the `templates/` directory
3. Adapt the template to your needs
4. Verify configuration correctness

## Available templates

### 1. Web Developer Template (`web-developer-template.yaml`)
- Suitable for frontend development tasks
- Limited access to web technologies (JS, TS, HTML, CSS, etc.)
- Includes web development best practices

### 2. API Developer Template (`api-developer-template.yaml`)
- Suitable for backend development tasks
- Limited access to server technologies (Python, Java, Go, etc.)
- Includes API creation recommendations

### 3. Mobile Developer Template (`mobile-developer-template.yaml`)
- Suitable for mobile development tasks
- Limited access to mobile technologies (Swift, Kotlin, Dart, etc.)
- Includes mobile development recommendations

## Process of creating a new Custom Mode

### Step 1: Mode purpose definition
Define the main purpose and functionality of the new mode:
- What tasks will be solved in this mode?
- Which technologies will be used?
- Which files should be accessible?

### Step 2: Template selection or creation
- If one of the existing templates suits, use it as a foundation
- If not, create a new template based on the general format

### Step 3: Parameter configuration
Configure the following parameters:
- `slug` - unique identifier for the mode
- `name` - display name
- `description` - brief description of purpose
- `roleDefinition` - main role and expertise
- `groups` - list of allowed tools and restrictions

### Step 4: Testing
- Install the mode in KiloCode
- Test it with various tasks
- Verify that restrictions work correctly

## Best practices

### When creating new modes:
1. **Clear naming**: use clear and descriptive names
2. **Security**: always limit file access with `fileRegex`
3. **Clear instructions**: provide clear roles and instructions
4. **Testing**: test each mode before use
5. **Documentation**: document the purpose and features of each mode

### When configuring restrictions:
- Use precise regular expressions to limit access
- Ensure expressions are properly escaped in YAML
- Verify that restrictions are neither too strict nor too lenient

## Troubleshooting

### Problem: Mode doesn't load
- Check YAML syntax
- Ensure `slug` is unique
- Verify that all required fields are present

### Problem: Restrictions don't work
- Check regular expressions for correctness
- Ensure they are properly escaped in YAML
- Test expressions separately

### Problem: Mode behaves unexpectedly
- Check `roleDefinition` for clarity and unambiguity
- Ensure `customInstructions` don't contradict each other
- Review the list of allowed tools

## Extending the skill

To add new templates:
1. Create a new file in the `templates/` directory
2. Follow the format of existing templates
3. Add description to this instruction file
4. Test the new template

To update main instructions:
1. Modify corresponding sections in `SKILL.md`
2. Update examples as needed
3. Test the changes
