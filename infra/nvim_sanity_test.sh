#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

TEST_DIR="$SCRIPT_DIR/test_files"
LOG_FILE="${NVIM_LOG_FILE:-$SCRIPT_DIR/nvim.log}"

print_status() {
    echo -e "\033[0;32m[+]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[x]\033[0m $1"
}

ensure_venv() {
    if [ -n "${VIRTUAL_ENV:-}" ]; then
        # shellcheck disable=SC1090
        source "$VIRTUAL_ENV/bin/activate"
        return
    fi

    local repo_root
    repo_root="$(cd "$SCRIPT_DIR/.." && pwd)"
    if [ ! -d "$repo_root/.venv" ]; then
        print_error "No active virtual environment and $repo_root/.venv is missing"
        exit 1
    fi

    # shellcheck disable=SC1091
    source "$repo_root/.venv/bin/activate"
}

run_headless() {
    local test_name=$1
    shift

    print_status "Running: $test_name"
    if nvim --headless "$@" >>"$LOG_FILE" 2>&1; then
        print_status "Success: $test_name"
        return 0
    fi

    print_error "Failed: $test_name"
    return 1
}

create_test_files() {
    mkdir -p "$TEST_DIR"

    cat >"$TEST_DIR/test.lua" <<'EOF'
local function add(a, b)
    return a + b
end

print(add(1, 2))
EOF

    cat >"$TEST_DIR/test.py" <<'EOF'
def add(a: int, b: int) -> int:
    return a + b


print(add(1, 2))
EOF

    cat >"$TEST_DIR/test.md" <<'EOF'
# Test Markdown

This file exists to exercise markdown startup paths.
EOF
}

cleanup() {
    rm -rf "$TEST_DIR"
    rm -f "$LOG_FILE"
}

main() {
    mkdir -p "$(dirname "$LOG_FILE")"
    : >"$LOG_FILE"

    ensure_venv
    run_final_checks
    create_test_files

    run_headless "Plugin bootstrap" "+Lazy! restore" "+qa" || exit 1
    run_headless "Basic startup" "+lua assert(package.loaded['lazy'], 'lazy.nvim did not load')" "+qa" || exit 1
    run_headless "Plugin availability" \
        "+lua assert(pcall(require, 'telescope'), 'telescope missing')" \
        "+lua assert(pcall(require, 'nvim-treesitter.configs'), 'treesitter missing')" \
        "+lua assert(pcall(require, 'nvim-treesitter-textobjects.select'), 'treesitter textobjects missing')" \
        "+lua assert(pcall(require, 'blink.cmp'), 'blink.cmp missing')" \
        "+lua assert(pcall(require, 'conform'), 'conform missing')" \
        "+lua assert(pcall(require, 'lint'), 'nvim-lint missing')" \
        "+lua assert(pcall(require, 'tabby'), 'tabby missing')" \
        "+lua assert(pcall(require, 'motleyfesst.utils.ssh'), 'utils.ssh missing')" \
        "+lua assert(pcall(require, 'motleyfesst.utils.lsp'), 'utils.lsp missing')" \
        "+lua assert(pcall(require, 'motleyfesst.utils.fold'), 'utils.fold missing')" \
        "+lua assert(pcall(require, 'motleyfesst.utils.bazel'), 'utils.bazel missing')" \
        "+qa" || exit 1
    run_headless "Commands available" \
        "+lua assert(vim.fn.exists(':Telescope') == 2, ':Telescope missing')" \
        "+lua assert(vim.fn.exists(':ConformInfo') == 2, ':ConformInfo missing')" \
        "+qa" || exit 1
    run_headless "Lua filetype" \
        "+edit $TEST_DIR/test.lua" \
        "+lua assert(vim.bo.filetype == 'lua', 'expected lua filetype')" \
        "+qa" || exit 1
    run_headless "Python filetype" \
        "+edit $TEST_DIR/test.py" \
        "+lua assert(vim.bo.filetype == 'python', 'expected python filetype')" \
        "+qa" || exit 1
    run_headless "Markdown filetype" \
        "+edit $TEST_DIR/test.md" \
        "+lua assert(vim.bo.filetype == 'markdown', 'expected markdown filetype')" \
        "+qa" || exit 1
    run_headless "Tree-sitter textobjects mappings" \
        "+lua assert(vim.fn.maparg('af', 'x') ~= '', 'expected af textobject mapping')" \
        "+lua assert(vim.fn.maparg('if', 'x') ~= '', 'expected if textobject mapping')" \
        "+qa" || exit 1
    run_headless "Health check" "+checkhealth" "+qa" || exit 1

    cleanup
    print_status "All sanity tests passed"
}

main "$@"
