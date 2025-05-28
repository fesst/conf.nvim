# Cargo packages
$CARGO_PACKAGES = @(
    "stylua"        # Required for Lua formatting
)

# Export variables
$env:CARGO_PACKAGES = $CARGO_PACKAGES -join " "
