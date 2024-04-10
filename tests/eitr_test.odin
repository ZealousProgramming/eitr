package eitr_tests

import "core:testing"

import "../"

@(test)
test_command_kind :: proc(t: ^testing.T) {
	testing.expect(t, eitr.command_matches("help", eitr.Command_Kind.Help))
	testing.expect(t, eitr.command_matches("HELP", eitr.Command_Kind.Help))
	testing.expect_value(
		t,
		eitr.command_matches("halp", eitr.Command_Kind.Help),
		false,
	)
	testing.expect_value(
		t,
		eitr.command_matches("run", eitr.Command_Kind.Help),
		false,
	)

	testing.expect(t, eitr.command_matches("init", eitr.Command_Kind.Init))
	testing.expect(t, eitr.command_matches("config", eitr.Command_Kind.Config))
	testing.expect(t, eitr.command_matches("run", eitr.Command_Kind.Run))
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
	// Verbose Run
	args_verbose_run := []string{"eitr.exe", "run", "-v"}
	testing.expect(
		t,
		eitr.contains_arg(args_verbose_run, eitr.Argument_Kind.Verbose),
	)
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
