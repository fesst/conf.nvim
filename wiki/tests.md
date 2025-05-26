# Testing Guide

This document describes the testing procedures and test files in the Neovim configuration.

## Test Structure

The test directory is organized as follows:

test/
├── setup/          # Test setup and utilities
├── lua/            # Lua-specific tests
├── test_cpp/       # C++ debugging tests
└── test_rust/      # Rust debugging tests

## Language-Specific Tests

### C++ Tests

Located in `test/test_cpp/`:

- Debugging configuration tests
- LSP integration tests
- CodeLLDB setup verification

### Rust Tests

Located in `test/test_rust/`:

- Debugging configuration tests
- LSP integration tests
- CodeLLDB setup verification

### Lua Tests

Located in `test/lua/`:

- Configuration validation
- Plugin loading tests
- Key mapping verification

## Test general nvim config

The `test/setup/` directory contains:

- Test environment configuration
- Common test utilities
- Mock data and fixtures

## Running Tests

### Local Testing

1. Run all tests:

   ```bash
   ./infra/nvim_sanity_test.sh
   ```

2. Run specific language tests:

   ```bash
   # C++ tests
   ./test/test_cpp/run_tests.sh

   # Rust tests
   ./test/test_rust/run_tests.sh

   # Lua tests
   ./test/lua/run_tests.sh
   ```

### CI/CD Testing

Tests are automatically run in the CI/CD pipeline:

- Sanity checks on every push
- Full test suite on pull requests
- Language-specific tests in parallel

## Test Categories

### Sanity Tests

- Basic Neovim startup
- Plugin loading
- Configuration validation

### Integration Tests

- LSP functionality
- Debugging setup
- Language server integration

## Writing Tests

When adding new tests:

1. Place them in the appropriate language directory
2. Follow the existing test patterns
3. Include proper setup and teardown
4. Document test requirements

## Test Dependencies

Tests may require:

- Language-specific tools
- Debug adapters
- LSP servers
see [infra](infrastructure.md)

## Troubleshooting

Common test issues:

1. Missing dependencies
2. Incorrect debug adapter setup
3. LSP server configuration

For more details, see the [Troubleshooting](README.md#troubleshooting) section in the README.
