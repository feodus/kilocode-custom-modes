# Workflow: Russian Commit with Memory Banr v2.0

You are an assistant that helps with creating Git commits. Follow these steps precisely with enhanced git tracking for memory bank updates.

### 1. Check for Changes
- Use `execute_command` to run `git status --porcelain`.
- If the output is empty, inform the user that there are no changes to commit and stop the workflow.

### 2. Get Git Log Information
- Use `execute_command` to run `git log --oneline -1` to get the latest commit hash
- Use `execute_command` to run `git log --since="1 hour ago" --oneline` to check for recent commits
- Store this information for potential memory bank update tracking

### 3. Get Diffs
- Use `execute_command` to run `git add . && git diff --staged` to stage all files and get the diff.
- Store the output of the diff.

### 4. Analyze Changes for Memory Bank Impact
- Examine the diff to identify if any memory bank files (`.kilocode/rules/memory-bank/`) were modified
- Check if core project files were modified that might require memory bank updates
- If memory bank files were changed, note this for the commit message

### 5. Generate Commit Message
- Based on the diff from the previous step, act as an expert developer and generate a concise, conventional commit message in **Russian**.
- The message MUST follow the Conventional Commits specification but in Russian (e.g., `feat: добавить новую кнопку входа`).
- Include prefix like `(memory-bank)` if memory bank files were modified
- **Do not ask the user for the message.** Generate it yourself based on the code changes.

### 6. Confirm with User
- Use the `ask_followup_question` tool to show the generated message to the user.
- The question should be: "I have generated the following commit message based on the changes:\n\n```\n{generated_message}\n```\n\nShould I proceed with this message?"
- Provide three suggested replies:
    1. "Yes, proceed with the commit."
    2. "No, let me write my own message."
    3. "Cancel."

### 7. Commit
- If the user chooses "Yes, proceed with the commit", use `execute_command` to run `git commit -m "{generated_message}"`.
- If the user chooses "No, let me write their own message", ask for their message and then run `git commit -m "{user_message}"`.
- If the user chooses "Cancel", stop the workflow.

### 8. Post-Commit Memory Bank Check
- After successful commit, check if the commit affects files that should be reflected in memory bank
- If core project files were changed (not just documentation), suggest updating the memory bank:
  - "Замечено, что вы изменили важные файлы проекта. Рекомендую обновить банк памяти, чтобы отразить эти изменения. Хотите выполнить 'update memory bank'?"

### 9. Push to Remote
- After the commit is successful, automatically use `execute_command` to run `git push`.
- Report the outcome of the push to the user.

### 10. Finish
- Inform the user that the commit has been successfully created and pushed.
- If memory bank update was recommended, remind the user about the suggestion.

### Prerequisites
- Switch to CODE mode using `switch_mode` tool before starting this workflow, as Git operations require CODE mode permissions.

# Workflow: Russian Commit with Memory Banr v2.0
