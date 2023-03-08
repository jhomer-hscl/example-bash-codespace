# Example of Better Script with Tests

## Overview

`src/read_config.bash` rewrite of the original [read_config.bash](../example-bad/src/read_config.bash) with the following improvements:

* Made testable using functions.
* Resolved [shellcheck](https://github.com/koalaman/shellcheck.net) problems.
* Added error handling.

`tests` unit tests with mocks written using [bats](https://github.com/bats-core/bats-core) and see also [Welcome to bats-core’s documentation!](https://bats-core.readthedocs.io/en/stable/index.html)

`tests/data` data used in the test scripts.

`.vscode/settings.json` example workspace settings with configuration for shfmt and column wrapping for `shellscript` files as per [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

## The Improvement Process

Explained this as there were more steps that expected, which is good.

### Address the `shellcheck` problems

This should be self explanatory, each problem has a reference to useful explanations in the [ShellCheck Wiki](https://www.shellcheck.net/wiki/)
 with guidance on how to fix and where exceptions may be relevant.

### Writing bats tests

See [test_read_config.bats](tests/test_read_config.bats).

The first part is to ensure that bats can be run. In this case `bats` on the shebang line and the test_helpers are loaded from paths in the environment, this is obviously environment specific.

```bash
#!/workspaces/example-bash-codespace/test/bats/bin/bats

load $CODESPACE_VSCODE_FOLDER/test/test_helper/bats-support/load
load $CODESPACE_VSCODE_FOLDER/test/test_helper/bats-assert/load
load $CODESPACE_VSCODE_FOLDER/test/test_helper/bats-file/load
```

The process started off with writing the success cases. There are just 2 scenarios:

* read_config successful with no input specified
* read_config successful with input specified"

Then we need to consider what else the code does. It checks to make sure TCP 8080 is not in use. We want to use a [mock object](https://en.wikipedia.org/wiki/Mock_object) to return the desired results of when we run `fuser` so we can test the scenario where TCP 8080 is in use.

We introduce the following scenario:

* read_config successful with input specified but tcp 8080 is in use

At this point it is sensible to also mock the normal case where TCP 8080 is not in use. This means we can ensure our tests are consistent and allow for us also having that port in use on another day without affecting the outcomes of the tests. As further tests are developed we will use this in all of them.

**Note:** This mock is going to be reused a lot. Should look at creating a fixture/helper for this.

New scenario for the success case is added:

* read_config successful with input specified, tcp 8080 is NOT in use - a better test

Start looking at the failure cases. First off this is pass in the name/path of a file that does not exist.

This showed no error checking for the initial invocation of `jq`, with error handling added we now have new scenario:

* read_config - a non-existent config file is specified

Additional test added for the remaining problem scenarios that were shown in [example-bad](../example-bad/README.md).

* read_config - a config file with a space is specified
* read_config - a config file which is invalid json

## Running the tests

If `bats` is in your path simply run `bats example-good/tests/test_read_condig.bats`.

If not then run `<path to bats>/bats example-good/tests/test_read_condig.bats`. The tests will run regardless of where you call them from.
