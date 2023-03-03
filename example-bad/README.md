# Example of Bad Script with no Working Tests

## Overview

`src/read_config.bash` based on a real world example but added problems for illustration purposes.

`tests` no tests were written for this script, but link to the test script [test_read_config.bats](../example-good/tests/test_read_config.bats) for the improved example is included and can be run from here.

`tests/data` test data that could/should have been used in unit tests for this script, wil be used in the good example to illustrate *better* practices.

## Running with test data

There were no tests we are lazy developers.

To illustrate the problems with this deliberately bad script you can run the following:

```bash
# Runs successfully produces badly formatted output

./src/read_config.bash

./src/read_config.bash tests/data/config.json
```

```bash
# Runs successfully(!) file does not exist, but prints an error message and garbage output

./src/read_config.bash tests/data/config
```

```bash
# Runs successfully(!) file has space but prints error messages and garbage output

./src/read_config.bash tests/data/config\ copy.json 
```

```bash
# Runs successfully(!) invalid json but prints error messages and garbage output

./src/read_config.bash tests/data/bad_json.json
```

```bash
# Runs successfully against an empty json document {} and returns garbage

./src/read_config.bash tests/data/empty_json.json
```

## Running tests from example-good

Now a proper job has been done the tests for example-good can be run and we can see how bad things really are by running the following from the `tests` directory using:

```bash
./test_read_config.bats 
```
