#!/bin/bash
# should_run_tests.sh
# Usage: bash infra/should_run_tests.sh <base_ref> <sha>
# Returns 0 if tests should run, 1 otherwise

BASE_REF="$1"
SHA="$2"

# Получаем список изменённых файлов
if git rev-parse --verify origin/"$BASE_REF" >/dev/null 2>&1; then
  CHANGED=$(git diff --name-only origin/"$BASE_REF" "$SHA")
else
  CHANGED=$(git diff --name-only HEAD^ HEAD)
fi

for file in $CHANGED; do
  if [[ "$file" =~ ^test/ ]] || [[ "$file" =~ ^infra/ ]] || [[ "$file" =~ \.lua$ ]]; then
    exit 0 # Нужно запускать тесты
  fi
done

exit 1 # Не нужно запускать тесты 