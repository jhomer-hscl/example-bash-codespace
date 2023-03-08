if [[ -z $CODESPACE_VSCODE_FOLDER ]]; then
    test_helper_path="$(dirname "$(dirname "$(dirname "$BATS_TEST_FILENAME")")")"/test/test_helper
else
    test_helper_path="$CODESPACE_VSCODE_FOLDER/test/test_helper"
fi

load "${test_helper_path}/bats-support/load.bash"
load "${test_helper_path}/bats-assert/load.bash"
load "${test_helper_path}/bats-file/load.bash"

setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
}

@test "read_config successful with no input specified" {
    # GIVEN:    No arguments are passed AND we hope nothing is using TCP port 8080
    # WHEN:     The script runs
    # THEN:     The values from the file are printed out

    run read_config.bash
    assert_success
    assert_line --index 0 --regexp '^Var1:\s+foo$'
    assert_line --index 1 --regexp '^Var2:\s+bar$'
}

@test "read_config successful with input specified" {
    # GIVEN:    No input file is specied AND we hope nothing is using TCP port 8080
    # WHEN:     The script runs
    # THEN:     The values from the file are printed out

    run read_config.bash "$(dirname "$BATS_TEST_FILENAME" )/data/config.json"
    assert_success
    assert_line --index 0 --regexp '^Var1:\s+foo$'
    assert_line --index 1 --regexp '^Var2:\s+bar$'
}

@test "read_config successful with input specified but tcp 8080 is in use" {
    # GIVEN:    No input file is specied AND TCP port 8080 is in use
    # WHEN:     The script runs
    # THEN:     No values are printed out AND a message is printed out

    # In this scenario we don't have anything running on tcp 8080 so will mock "fuser"

    function fuser() {
        echo "fuser 8080/tcp"
        return 0
    }
    export -f fuser

    run read_config.bash "$(dirname "$BATS_TEST_FILENAME" )/data/config.json"

    unset fuser

    assert_success
    assert_line --index 0 "We checked something and didn't need to print out anything"
}

@test "read_config successful with input specified, tcp 8080 is NOT in use - a better test" {
    # GIVEN:    No input file is specied AND we KNOW TCP port 8080 is NOT in use
    # WHEN:     The script runs
    # THEN:     The values from the file are printed out

    # In this scenario we want to make sure that nothing is running on TCP 8080,
    # something else on the system maybe and that will affect our test.

    function fuser() {
        return 1
    }
    export -f fuser

    run read_config.bash "$(dirname "$BATS_TEST_FILENAME" )/data/config.json"

    unset fuser

    assert_success
    assert_line --index 0 --regexp '^Var1:\s+foo$'
    assert_line --index 1 --regexp '^Var2:\s+bar$'
}

@test "read_config - a non exsistent config file is specifed" {
    # GIVEN:    An invalid file is specified AND we KNOW TCP port 8080 is NOT in use
    # WHEN:     The script runs
    # THEN:     No values are printed out AND a message is printed out

    # In this scenario we can pass an invalid file name, i.e. it does not exist
    # If we write our tests as we develop this helps us develop better code. This
    # test intially threw up the following
    
        # ✗ read_config - a non exsistent config file is specified
        # (from function `assert_line' in file /workspaces/example-bash-codespace/test/test_helper/bats-assert/src/assert_line.bash, line 184,
        # in test file test_read_config.bats, line 90)
        #  `assert_line --index 0 --regexp '^Var1:\s+foo$'' failed
        # 
        # -- regular expression does not match line --
        # index  : 0
        # regexp : ^Var1:\s+foo$
        # line   : jq: error: Could not open file data/config_does_not_exist.json: No such file or directory
        # --
        #
        # 
        # 5 tests, 1 failure

    # The test has passed the "assert_failues" because there was no error handling

    function fuser() {
        return 1
    }
    export -f fuser

    run read_config.bash "$(dirname "$BATS_TEST_FILENAME" )/data/config_does_not_exist.json"

    unset fuser

    assert_failure
    assert_line --index 0 "jq: error: Could not open file $(dirname "$BATS_TEST_FILENAME" )/data/config_does_not_exist.json: No such file or directory"
    assert_line --index 1 "Error reading config: $(dirname "$BATS_TEST_FILENAME" )/data/config_does_not_exist.json"

}

@test "read_config - a config file with a space is specified" {
    # GIVEN:    An file with a space in the name is specified AND we KNOW TCP port 8080 is NOT in use
    # WHEN:     The script runs
    # THEN:     The values from the file are printed out

    # In this scenario we pass an valid file name but it has a space in it.
    # This will test that the problems suggested by shellcheck has been addressed.
    
    function fuser() {
        return 1
    }
    export -f fuser

    run read_config.bash "$(dirname "$BATS_TEST_FILENAME" )/data/config copy.json"

    unset fuser

    assert_success
    assert_line --index 0 --regexp '^Var1:\s+this$'
    assert_line --index 1 --regexp '^Var2:\s+that$'

}

@test "read_config - a config file which is invalid json" {
    # GIVEN:    An invalid json file is specified AND we KNOW TCP port 8080 is NOT in use
    # WHEN:     The script runs
    # THEN:     The script fails and the error is printed out

    # In this scenario we pass an valid file name but the json content is invalid
    
    function fuser() {
        return 1
    }
    export -f fuser

    run read_config.bash "$(dirname "$BATS_TEST_FILENAME" )/data/bad_json.json"

    unset fuser

    assert_failure
    assert_line --index 0 --regexp '^parse error: Expected separator between values at line [[:digit:]]+, column [[:digit:]]+$'

}

@test "read_config and set default values if they aren't set" {
    # GIVEN:    Specify a file that is an empty json document
    #           AND we KNOW nothing is using TCP port 8080
    # WHEN:     The script runs
    # THEN:     The default values are printed out

    function fuser() {
        return 1
    }
    export -f fuser

    run read_config.bash "$(dirname "$BATS_TEST_FILENAME" )/data/empty_json.json"

    unset fuser

    assert_success
    assert_line --index 0 --regexp '^Var1:\s+value1$'
    assert_line --index 1 --regexp '^Var2:\s+value2$'
}
