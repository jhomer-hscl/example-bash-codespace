# example-bash-codespace

## Overview

Example codespace for bash programming, includes bats, shellcheck, shfmt and other useful plugins and configuration for simple projects and demonstrating basic code quality and testing methodologies.

## Example Scripts

### example-bad

This is a script with problems and no tests.

It is partially from a real world exampled picked out for a learning / teaching exercise in how to use available code quality tools like `shellcheck` and a level of testing for shell scripts using `bats`.

### example-good

This is the ~~fixed~~improved version that addresses:

* Problems identified with shellcheck.
* Basic error handling where required to get sensible behaviour.
* Lack of unit tests

### Using

Feel free to fork this repository it comes with setup for github codespace and a number of useful plugins for shell scripting with in VSCode.

You should easily be able to look at the VSCode problem reporting, which this is intended to highlight, run the tests, etc. within the free personal allowances.

Alternatively, clone the repo and work locally.

### Contributing

I'm not looking to take contributions via Pull Requests. But feel free raise an issue if there is something glaringly incorrect as opposed could be better.
