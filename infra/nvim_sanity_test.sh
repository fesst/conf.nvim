#!/bin/bash
set -euo pipefail

# Source lib.sh for common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

TEST_DIR="infra/test_files"
LOG_FILE="${NVIM_LOG_FILE:-infra/nvim.log}"
VENV_DIR=".venv"

# Function to print status messages
print_status() {
    echo -e "\033[0;32m[+]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[x]\033[0m $1"
}

# Function to ensure virtual environment is activated
ensure_venv() {
    if [ -n "${VIRTUAL_ENV:-}" ]; then
        print_status "Using existing virtual environment: $VIRTUAL_ENV"
        source "$VIRTUAL_ENV/bin/activate" || {
            print_error "Failed to activate virtual environment"
            exit 1
        }
    elif [ ! -d "$VENV_DIR" ]; then
        print_error "Virtual environment not found at $VENV_DIR"
        exit 1
    else
        print_status "Activating virtual environment..."
        source "$VENV_DIR/bin/activate" || {
            print_error "Failed to activate virtual environment"
            exit 1
        }
    fi
}

# Function to run nvim command with logging
run_nvim() {
    local cmd="$1"
    local test_name="$2"

    print_status "Running: $test_name"
    if nvim --headless -c "$cmd" -c 'quit' 2>> "$LOG_FILE"; then
        print_status "Success: $test_name"
        return 0
    else
        print_error "Failed: $test_name"
        echo "Command: $cmd" >> "$LOG_FILE"
        return 1
    fi
}

# Function to run lua command with logging
run_lua() {
    local cmd="$1"
    local test_name="$2"

    print_status "Running: $test_name"
    if nvim --headless -c "lua $cmd" -c 'quit' 2>> "$LOG_FILE"; then
        print_status "Success: $test_name"
        return 0
    else
        print_error "Failed: $test_name"
        echo "Lua Command: $cmd" >> "$LOG_FILE"
        return 1
    fi
}

# Create test files
create_test_files() {
    print_status "Creating test files..."
    mkdir -p "$TEST_DIR"

    # Create test.lua
    cat > "$TEST_DIR/test.lua" << 'EOF'
local function test()
    print("Test function")
end
test()
EOF

    # Create test.md
    cat > "$TEST_DIR/test.md" << 'EOF'
# Test Markdown
This is a test markdown file.
EOF

    # Create test.py
    cat > "$TEST_DIR/test.py" << 'EOF'
def test():
    print("Test function")

if __name__ == "__main__":
    test()
EOF
}

# Test functions
test_basic_functionality() {
    print_status "Testing basic functionality..."

    if ! check_command nvim; then
        print_error "Neovim is not installed"
        exit 1
    fi

    run_nvim 'quit' "Basic startup/exit" || exit 1
    run_nvim "e $TEST_DIR/test.lua" "Lua file test" || exit 1
    run_nvim "e $TEST_DIR/test.md" "Markdown file test" || exit 1
    run_nvim "e $TEST_DIR/test.py" "Python file test" || exit 1
}

test_health_check() {
    print_status "Running health check..."
    mkdir -p "$TEST_DIR"

    if nvim --headless -c 'checkhealth' -c 'quit' 2>&1 | tee "$TEST_DIR/checkhealth.log"; then
        print_status "checkhealth completed successfully"
    else
        print_error "checkhealth failed"
        exit 1
    fi
}

test_core_plugins() {
    print_status "Testing core plugin loading..."

    run_lua 'if not package.loaded["lazy"] then error("Lazy not loaded") end' "Lazy plugin test" || exit 1
    run_lua 'if not package.loaded["nvim-treesitter"] then error("Treesitter not loaded") end' "Treesitter plugin test" || exit 1
    run_nvim "e $TEST_DIR/test.py" "LSP config test" || exit 1
    run_lua 'if not package.loaded["nvim-lspconfig"] then error("LSP config not loaded") end' "LSP config plugin test" || exit 1
    run_lua 'if not package.loaded["mason"] then error("Mason not loaded") end' "Mason plugin test" || exit 1
    run_lua 'if not package.loaded["telescope"] then error("Telescope not loaded") end' "Telescope plugin test" || exit 1
}

test_treesitter() {
    print_status "Testing Treesitter functionality..."
    nvim --headless -c 'lua if not require("nvim-treesitter").statusline() then error("Treesitter not functioning") end' -c 'quit' || { print_error "Treesitter functionality test failed"; exit 1; }
}

test_harpoon() {
    print_status "Testing Harpoon functionality..."
    print_status "Testing Harpoon loading..."
    nvim --headless -c 'lua if not package.loaded["harpoon"] then error("Harpoon not loaded") end' -c 'quit' || { print_error "Harpoon loading test failed"; exit 1; }

    print_status "Testing Harpoon mark functionality..."
    nvim --headless -c 'lua if not require("harpoon.mark").add_file then error("Harpoon mark functionality not available") end' -c 'quit' || { print_error "Harpoon mark functionality test failed"; exit 1; }
}

test_postgres() {
    print_status "Testing PostgreSQL functionality..."
    print_status "Testing SQL LSP loading..."
    nvim --headless -c 'lua if not package.loaded["sqlls"] then error("SQL LSP not loaded") end' -c 'quit' || { print_error "SQL LSP loading test failed"; exit 1; }

    print_status "Testing SQL LSP config..."
    nvim --headless -c 'lua if not require("lspconfig").sqlls then error("SQL LSP config not available") end' -c 'quit' || { print_error "SQL LSP config test failed"; exit 1; }
}

test_text_file_handling() {
    print_status "Testing text file handling..."
    # Create a test text file
    echo "This is a test text file" > "$TEST_DIR/test.txt"

    print_status "Testing text file LSP..."
    nvim --headless -c "e $TEST_DIR/test.txt" -c 'lua if #vim.lsp.get_clients() > 0 then error("LSP client should not be attached to text files") end' -c 'quit' || { print_error "Text file LSP test failed"; exit 1; }

    print_status "Testing markdown file LSP..."
    echo "# Test Markdown" > "$TEST_DIR/test.md"
    nvim --headless -c "e $TEST_DIR/test.md" -c 'lua if #vim.lsp.get_clients() > 0 then error("LSP client should not be attached to markdown files") end' -c 'quit' || { print_error "Markdown file LSP test failed"; exit 1; }

    print_status "Verifying no LSP clients on text files..."
    nvim --headless -c "e $TEST_DIR/test.txt" -c 'lua if #vim.lsp.get_clients() > 0 then error("No LSP clients should be attached to text files") end' -c 'quit' || { print_error "Text file LSP verification failed"; exit 1; }
}

cleanup() {
    print_status "Cleaning up test files..."
    rm -rf "$TEST_DIR"
    rm -f "$LOG_FILE"
}

# Main test execution
print_status "Running Neovim sanity tests..."

# Initialize log file
mkdir -p "$(dirname "$LOG_FILE")"
echo "=== Neovim Test Log $(date) ===" > "$LOG_FILE"

# Ensure virtual environment is activated
ensure_venv

# Run final checks from lib.sh
run_final_checks

create_test_files
test_basic_functionality
test_health_check
test_core_plugins
test_treesitter
test_harpoon
test_postgres
test_text_file_handling
cleanup

print_status "All sanity tests passed successfully!"
