setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"

    source $DIR/../src/functions.sh

    load test_helper/bats-support/load
    load test_helper/bats-assert/load
    load test_helper/bats-file/load
}

# teardown() {
#     rm -rf ${BATS_TEST_TMPDIR}
# }

@test "test file created" {
    test_file="${BATS_TMPDIR}/foo"
    run create_file "$test_file"
    assert_exists "$test_file"
}

@test "test file with spaces in name created" {
    test_file="${BATS_TMPDIR}/foo bar"
    run create_file "$test_file"
    assert_exists "$test_file"
}