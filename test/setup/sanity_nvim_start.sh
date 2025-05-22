#!/bin/bash
set -euo pipefail

TEST_DIR="test/setup/test_files"

# Function to print status messages
print_status() {
    echo -e "\033[0;32m[+]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[x]\033[0m $1"
}

# Test functions
test_basic_functionality() {
    print_status "Testing basic functionality..."
    print_status "Testing basic startup/exit..."
    nvim --headless -c 'quit' || { print_error "Basic startup failed"; exit 1; }
    
    print_status "Testing Lua file..."
    nvim --headless -c "e $TEST_DIR/test.lua" -c 'quit' || { print_error "Lua file test failed"; exit 1; }
    
    print_status "Testing Markdown file..."
    nvim --headless -c "e $TEST_DIR/test.md" -c 'quit' || { print_error "Markdown file test failed"; exit 1; }
    
    print_status "Testing Python file..."
    nvim --headless -c "e $TEST_DIR/test.py" -c 'quit' || { print_error "Python file test failed"; exit 1; }
}

test_health_check() {
    print_status "Running health check..."
    # Ensure test directory exists
    mkdir -p "$TEST_DIR"
    
    # Run checkhealth and only check the exit code
    if nvim --headless -c 'checkhealth' -c 'quit' 2>&1 | tee "$TEST_DIR/checkhealth.log"; then
        print_status "checkhealth completed successfully"
    else
        print_error "checkhealth failed"
        exit 1
    fi
}

test_core_plugins() {
    print_status "Testing core plugin loading..."
    print_status "Testing Lazy..."
    nvim --headless -c 'lua if not package.loaded["lazy"] then error("Lazy not loaded") end' -c 'quit' || { print_error "Lazy plugin test failed"; exit 1; }
    
    print_status "Testing Treesitter..."
    nvim --headless -c 'lua if not package.loaded["nvim-treesitter"] then error("Treesitter not loaded") end' -c 'quit' || { print_error "Treesitter plugin test failed"; exit 1; }
    
    print_status "Testing LSP config..."
    nvim -c "e $TEST_DIR/test.py" -c 'lua if not package.loaded["nvim-lspconfig"] then error("LSP config not loaded") end' -c 'quit' || { print_error "LSP config plugin test failed"; exit 1; }
    
    print_status "Testing Mason..."
    nvim --headless -c 'lua if not package.loaded["mason"] then error("Mason not loaded") end' -c 'quit' || { print_error "Mason plugin test failed"; exit 1; }
    
    print_status "Testing Telescope..."
    nvim --headless -c 'lua if not package.loaded["telescope"] then error("Telescope not loaded") end' -c 'quit' || { print_error "Telescope plugin test failed"; exit 1; }
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
    rm -f "$TEST_DIR/test.lua" "$TEST_DIR/test.md" "$TEST_DIR/test.py" "$TEST_DIR/test.txt" "$TEST_DIR/checkhealth.log"
}

# Main test execution
print_status "Running Neovim sanity tests..."

test_basic_functionality
test_health_check
test_core_plugins
test_treesitter
test_harpoon
test_postgres
test_text_file_handling
cleanup

print_status "All sanity tests passed successfully!" 