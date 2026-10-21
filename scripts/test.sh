
#!/usr/bin/env bash

set -uo pipefail

FAILED=0

# Run a check and report its result.
run_check() {
    local name="$1"
    shift

    if "$@"; then
        echo "OK: $name"
    else
        echo "FAIL: $name"
        FAILED=1
    fi
}

# Check that README.md exists.
check_readme_exists() {
    if [[ -f README.md ]]; then
        return 0
    fi

    echo "README.md does not exist."
    return 1
}

# Check that .gitignore exists.
check_gitignore_exists() {
    if [[ -f .gitignore ]]; then
        return 0
    fi

    echo ".gitignore does not exist."
    return 1
}

# Check that README.md contains a Markdown heading.
check_readme_heading() {
    if [[ ! -f README.md ]]; then
        echo "Cannot check README.md heading because the file is missing."
        return 1
    fi

    if grep -qE '^#[[:space:]]+.+$' README.md; then
        return 0
    fi

    echo "README.md does not contain a valid level-one Markdown heading."
    return 1
}

echo "Starting repository checks..."

run_check "README.md exists" check_readme_exists
run_check ".gitignore exists" check_gitignore_exists
run_check "README.md contains a heading" check_readme_heading

echo

if [[ "$FAILED" -eq 0 ]]; then
    echo "OK: All checks passed."
    exit 0
else
    echo "FAIL: One or more checks failed."
    exit 1
fi
