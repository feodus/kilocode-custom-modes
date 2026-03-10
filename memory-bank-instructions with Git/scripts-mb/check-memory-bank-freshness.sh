#!/bin/bash

# Скрипт для проверки актуальности банка памяти
# Сравнивает дату последнего обновления банка памяти с датой последнего git коммита

echo "Проверка актуальности банка памяти..."

# Get the latest commit date
LATEST_COMMIT_DATE=$(git log -1 --format="%ai")
LATEST_COMMIT_HASH=$(git log -1 --format="%h")

echo "Дата последнего коммита: $LATEST_COMMIT_DATE"
echo "Хэш последнего коммита: $LATEST_COMMIT_HASH"

# Check the modification date of the most recently updated memory bank file
MEMORY_BANK_PATH=".kilocode/rules/memory-bank"
if [ -d "$MEMORY_BANK_PATH" ]; then
    # Find the most recently modified file in the memory bank directory
    LATEST_MEMORY_BANK_FILE=$(find "$MEMORY_BANK_PATH" -type f -exec stat -f "%m %N" {} \; | sort -nr | head -1 | cut -d' ' -f2-)
    LATEST_MEMORY_BANK_DATE=$(stat -f "%Sm" "$LATEST_MEMORY_BANK_FILE")
    
    echo "Последний обновлённый файл банка памяти: $LATEST_MEMORY_BANK_FILE"
    echo "Последнее обновление банка памяти: $LATEST_MEMORY_BANK_DATE"
    
    # Convert dates to Unix timestamps for comparison
    COMMIT_TIMESTAMP=$(date -jf "%Y-%m-%d %H:%M:%S %z" "$LATEST_COMMIT_DATE" +%s 2>/dev/null)
    MEMORY_BANK_TIMESTAMP=$(stat -f "%m" "$LATEST_MEMORY_BANK_FILE" 2>/dev/null || stat -c "%Y" "$LATEST_MEMORY_BANK_FILE")
    
    if [ "$COMMIT_TIMESTAMP" -gt "$MEMORY_BANK_TIMESTAMP" ]; then
        echo
        echo "ПРЕДУПРЕЖДЕНИЕ: Репозиторий был обновлён после последнего обновления банка памяти!"
        echo "Рекомендуется выполнить 'update memory bank' для синхронизации документации."
        echo
        echo "Файлы, изменённые после последнего обновления банка памяти:"
        git diff --name-only "$(git log --until="$(perl -e "print scalar localtime($MEMORY_BANK_TIMESTAMP)")" -1 --format="%h")" HEAD
    else
        echo
        echo "OK: Банк памяти актуален с последними изменениями."
    fi
else
    echo "ОШИБКА: Директория банка памяти не найдена в $MEMORY_BANK_PATH"
fi
