#!/bin/bash
set -euo pipefail

# Test functions
test_basic_functionality() {
    echo "Testing basic functionality..."
    nvim --headless -c 'quit'  # Basic startup/exit
    nvim --headless -c 'e test/setup/test.lua' -c 'quit'  # Lua file
    nvim --headless -c 'e test/setup/test.md' -c 'quit'  # Markdown file
    nvim --headless -c 'e test/setup/test.py' -c 'quit'  # Python file
}

test_health_check() {
    echo "Running health check..."
    nvim --headless -c 'checkhealth' -c 'quit' | tee test/setup/checkhealth.log
    grep -q 'health#' test/setup/checkhealth.log && echo "checkhealth ran. Review test/setup/checkhealth.log for issues."
}

test_core_plugins() {
    echo "Testing core plugin loading..."
    nvim --headless -c 'lua if not package.loaded["lazy"] then error("Lazy not loaded") end' -c 'quit'
    nvim --headless -c 'lua if not package.loaded["nvim-treesitter"] then error("Treesitter not loaded") end' -c 'quit'
    nvim --headless -c 'lua if not package.loaded["nvim-lspconfig"] then error("LSP config not loaded") end' -c 'quit'
    nvim --headless -c 'lua if not package.loaded["mason"] then error("Mason not loaded") end' -c 'quit'
    nvim --headless -c 'lua if not package.loaded["telescope"] then error("Telescope not loaded") end' -c 'quit'
}

test_treesitter() {
    echo "Testing Treesitter functionality..."
    nvim --headless -c 'lua if not require("nvim-treesitter").statusline() then error("Treesitter not functioning") end' -c 'quit'
}

test_harpoon() {
    echo "Testing Harpoon functionality..."
    nvim --headless -c 'lua if not package.loaded["harpoon"] then error("Harpoon not loaded") end' -c 'quit'
    nvim --headless -c 'lua if not require("harpoon.mark").add_file then error("Harpoon mark functionality not available") end' -c 'quit'
}

test_postgres() {
    echo "Testing PostgreSQL functionality..."
    nvim --headless -c 'lua if not package.loaded["sqlls"] then error("SQL LSP not loaded") end' -c 'quit'
    nvim --headless -c 'lua if not require("lspconfig").sqlls then error("SQL LSP config not available") end' -c 'quit'
}

test_text_file_handling() {
    echo "Testing text file handling..."
    # Create a test text file
    echo "This is a test text file" > test/setup/test.txt
    
    # Test opening text file without LSP errors
    nvim --headless -c 'e test/setup/test.txt' -c 'lua if #vim.lsp.get_clients() > 0 then error("LSP client should not be attached to text files") end' -c 'quit'
    
    # Test markdown file handling
    echo "# Test Markdown" > test/setup/test.md
    nvim --headless -c 'e test/setup/test.md' -c 'lua if #vim.lsp.get_clients() > 0 then error("LSP client should not be attached to markdown files") end' -c 'quit'
    
    # Verify no LSP clients are attached to text files
    nvim --headless -c 'e test/setup/test.txt' -c 'lua if #vim.lsp.get_clients() > 0 then error("No LSP clients should be attached to text files") end' -c 'quit'
}

cleanup() {
    echo "Cleaning up test files..."
    rm -f test/setup/test.lua test/setup/test.md test/setup/test.py test/setup/test.txt test/setup/checkhealth.log
}

# Main test execution
echo "Running Neovim sanity tests..."

test_basic_functionality
test_health_check
test_core_plugins
test_treesitter
test_harpoon
test_postgres
test_text_file_handling
cleanup

echo "All sanity tests passed successfully!" 