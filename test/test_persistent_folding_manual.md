# Persistent Folding Test

## Steps for Testing

1. Open this file in Neovim: `nvim test/test_persistent_folding_manual.md`

2. Close all folds: `zM`

3. Save the view: `:mkview`

4. Close the file: `:q`

5. Reopen the file: `nvim test/test_persistent_folding_manual.md`

6. Verify that the folds remain closed

## Alternative Test

1. Open the file: `nvim test/test_persistent_folding_manual.md`

2. Use the commands:
   - `<leader>vs` - save the view
   - `<leader>vl` - load the view
   - `<leader>vr` - force load the view

## Expected Result

- The folding state should persist between sessions
- View files should be created in `~/.local/share/nvim/view/`
- Automatic loading should work when reopening the file
