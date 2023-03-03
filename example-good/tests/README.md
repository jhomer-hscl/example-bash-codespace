# Testing

Tests can be run from the `tests` directory by:

```bash
@jhomer-hscl ➜ /workspaces/example-bash-codespace/example-good/tests (develop) $ ./test_read_config.bats 
test_read_config.bats
 ✓ read_config successful with no input specified
 ✓ read_config successful with input specified
 ✓ read_config successful with input specified but tcp 8080 is in use
 ✓ read_config successful with input specified, tcp 8080 is NOT in use - a better test
 ✓ read_config - a non existent config file is specified
 ✓ read_config - a config file with a space is specified
 ✓ read_config - a config file which is invalid json

7 tests, 0 failures
```
