package eitr_tests

import "core:testing"

import "../"

@(test)
test_parse_command :: proc(t: ^testing.T) {
	MockParseCommand :: struct {
		command:  []string,
		expected: eitr.Eitr_Errors,
	}

	commands := []MockParseCommand {
		// --- Failure
		MockParseCommand {
			command = []string{"C:\\programming\\odin\\eitr\\bin\\eitr.exe"},
			expected = .Command_Not_Found,
		},
		MockParseCommand {
			command = []string {
				"C:\\programming\\odin\\eitr\\bin\\eitr.exe",
				"build",
				"-v",
			},
			expected = .Command_Not_Found,
		},
		MockParseCommand {
			command = []string {
				"C:\\programming\\odin\\eitr\\bin\\eitr.exe",
				"BUILD",
				"-v",
			},
			expected = .Command_Not_Found,
		},
		// --- Success
		MockParseCommand {
			command = []string {
				"C:\\programming\\odin\\eitr\\bin\\eitr.exe",
				"help",
			},
			expected = .None,
		},
		MockParseCommand {
			command = []string {
				"C:\\programming\\odin\\eitr\\bin\\eitr.exe",
				"init",
			},
			expected = .None,
		},
		MockParseCommand {
			command = []string {
				"C:\\programming\\odin\\eitr\\bin\\eitr.exe",
				"config",
			},
			expected = .None,
		},
		MockParseCommand {
			command = []string {
				"C:\\programming\\odin\\eitr\\bin\\eitr.exe",
				"config",
				"-s",
			},
			expected = .None,
		},
		MockParseCommand {
			command = []string {
				"C:\\programming\\odin\\eitr\\bin\\eitr.exe",
				"run",
			},
			expected = .None,
		},
	}

	cmds := make([dynamic]eitr.Command)
	defer delete(cmds)

	for cmd in commands {
		testing.expect_value(
			t,
			eitr.parse_command(cmd.command, &cmds, context.temp_allocator),
			cmd.expected,
		)
	}
}

@(test)
test_command_kind :: proc(t: ^testing.T) {
	MockCommandMatches :: struct {
		command:  string,
		kind:     eitr.Command_Kind,
		expected: bool,
	}

	commands := []MockCommandMatches {
		MockCommandMatches {
			command = "help",
			kind = eitr.Command_Kind.Help,
			expected = true,
		},
		MockCommandMatches {
			command = "HELP",
			kind = eitr.Command_Kind.Help,
			expected = true,
		},
		MockCommandMatches {
			command = "HelP",
			kind = eitr.Command_Kind.Help,
			expected = true,
		},
		MockCommandMatches {
			command = "halp",
			kind = eitr.Command_Kind.Help,
			expected = false,
		},
		MockCommandMatches {
			command = "run",
			kind = eitr.Command_Kind.Help,
			expected = false,
		},
		MockCommandMatches {
			command = "run",
			kind = eitr.Command_Kind.Run,
			expected = true,
		},
		MockCommandMatches {
			command = "init",
			kind = eitr.Command_Kind.Init,
			expected = true,
		},
		MockCommandMatches {
			command = "config",
			kind = eitr.Command_Kind.Config,
			expected = true,
		},
	}

	for c in commands {
		testing.expect_value(
			t,
			eitr.command_matches(c.command, c.kind),
			c.expected,
		)
	}
}

@(test)
test_argument_kind :: proc(t: ^testing.T) {
	MockFindArgs :: struct {
		arg:           string,
		expected_kind: eitr.Argument_Kind,
		err:           eitr.Eitr_Errors,
	}

	args := []MockFindArgs {
		// --- Failures
		MockFindArgs {
			arg = "-z",
			expected_kind = eitr.Argument_Kind.Invalid,
			err = eitr.Eitr_Errors.Unknown_Argument,
		},
		MockFindArgs {
			arg = "--zebracakes",
			expected_kind = eitr.Argument_Kind.Invalid,
			err = eitr.Eitr_Errors.Unknown_Argument,
		},
		MockFindArgs {
			arg = "--h",
			expected_kind = eitr.Argument_Kind.Invalid,
			err = eitr.Eitr_Errors.Unknown_Argument,
		},
		MockFindArgs {
			arg = "-verbose",
			expected_kind = eitr.Argument_Kind.Invalid,
			err = eitr.Eitr_Errors.Unknown_Argument,
		},
		// --- Successes

		// Help
		MockFindArgs {
			arg = "-h",
			expected_kind = eitr.Argument_Kind.Command_Help,
			err = eitr.Eitr_Errors.None,
		},
		MockFindArgs {
			arg = "--help",
			expected_kind = eitr.Argument_Kind.Command_Help,
			err = eitr.Eitr_Errors.None,
		},

		// Verbose
		MockFindArgs {
			arg = "-v",
			expected_kind = eitr.Argument_Kind.Verbose,
			err = eitr.Eitr_Errors.None,
		},
		MockFindArgs {
			arg = "--verbose",
			expected_kind = eitr.Argument_Kind.Verbose,
			err = eitr.Eitr_Errors.None,
		},

		// Config
		MockFindArgs {
			arg = "-c",
			expected_kind = eitr.Argument_Kind.Configuration,
			err = eitr.Eitr_Errors.None,
		},
		MockFindArgs {
			arg = "--config",
			expected_kind = eitr.Argument_Kind.Configuration,
			err = eitr.Eitr_Errors.None,
		},

		// Output
		MockFindArgs {
			arg = "-o",
			expected_kind = eitr.Argument_Kind.Output,
			err = eitr.Eitr_Errors.None,
		},
		MockFindArgs {
			arg = "--output",
			expected_kind = eitr.Argument_Kind.Output,
			err = eitr.Eitr_Errors.None,
		},

		// Set
		MockFindArgs {
			arg = "-s",
			expected_kind = eitr.Argument_Kind.Set,
			err = eitr.Eitr_Errors.None,
		},
		MockFindArgs {
			arg = "--set",
			expected_kind = eitr.Argument_Kind.Set,
			err = eitr.Eitr_Errors.None,
		},

		// Directory
		MockFindArgs {
			arg = "-d",
			expected_kind = eitr.Argument_Kind.Scope_Directory,
			err = eitr.Eitr_Errors.None,
		},
		MockFindArgs {
			arg = "--directory",
			expected_kind = eitr.Argument_Kind.Scope_Directory,
			err = eitr.Eitr_Errors.None,
		},

		// Profile
		MockFindArgs {
			arg = "-p",
			expected_kind = eitr.Argument_Kind.Profile,
			err = eitr.Eitr_Errors.None,
		},
		MockFindArgs {
			arg = "--profile",
			expected_kind = eitr.Argument_Kind.Profile,
			err = eitr.Eitr_Errors.None,
		},
	}

	for a in args {
		actual, err := eitr.find_arg(a.arg)
		testing.expect(t, actual == a.expected_kind)
		testing.expect(t, err == a.err)
	}
}

@(test)
test_contains_arg :: proc(t: ^testing.T) {
	MockContainsArg :: struct {
		args:     []string,
		kind:     eitr.Argument_Kind,
		expected: bool,
	}

	args := []MockContainsArg {
		MockContainsArg {
			args = []string{"eitr.exe", "run", "-z"},
			kind = eitr.Argument_Kind.Verbose,
			expected = false,
		},
		MockContainsArg {
			args = []string{"eitr.exe", "run", "--Halp"},
			kind = eitr.Argument_Kind.Command_Help,
			expected = false,
		},
		MockContainsArg {
			args = []string{"eitr.exe", "run", "-v"},
			kind = eitr.Argument_Kind.Verbose,
			expected = true,
		},
		MockContainsArg {
			args = []string{"eitr.exe", "run", "--help"},
			kind = eitr.Argument_Kind.Command_Help,
			expected = true,
		},
		MockContainsArg {
			args = []string{"eitr.exe", "run", "-v", "--output"},
			kind = eitr.Argument_Kind.Output,
			expected = true,
		},
		MockContainsArg {
			args = []string{"eitr.exe", "run", "--profile"},
			kind = eitr.Argument_Kind.Profile,
			expected = true,
		},
	}

	for a in args {
		testing.expect_value(t, eitr.contains_arg(a.args, a.kind), a.expected)
	}
}

@(test)
test_command_by_name :: proc(t: ^testing.T) {
	MockCommandByNames :: struct {
		command:       string,
		expected_kind: eitr.Command_Kind,
		err:           eitr.Eitr_Errors,
	}

	commands := []MockCommandByNames {
		// Failures
		MockCommandByNames {
			command = "build",
			expected_kind = eitr.Command_Kind.Invalid,
			err = .Command_Not_Found,
		},
		MockCommandByNames {
			command = "rub",
			expected_kind = eitr.Command_Kind.Invalid,
			err = .Command_Not_Found,
		},

		// Sucessess
		MockCommandByNames {
			command = "RUn",
			expected_kind = eitr.Command_Kind.Run,
			err = .None,
		},
		MockCommandByNames {
			command = "config",
			expected_kind = eitr.Command_Kind.Config,
			err = .None,
		},
		MockCommandByNames {
			command = "ConfiG",
			expected_kind = eitr.Command_Kind.Config,
			err = .None,
		},
		MockCommandByNames {
			command = "help",
			expected_kind = eitr.Command_Kind.Help,
			err = .None,
		},
		MockCommandByNames {
			command = "heLP",
			expected_kind = eitr.Command_Kind.Help,
			err = .None,
		},
		MockCommandByNames {
			command = "iNIt",
			expected_kind = eitr.Command_Kind.Init,
			err = .None,
		},
	}

	for c in commands {
		actual_cmd, err := eitr.command_by_name(c.command)

		testing.expect_value(t, actual_cmd, c.expected_kind)
		testing.expect(t, err == c.err)
	}

}
