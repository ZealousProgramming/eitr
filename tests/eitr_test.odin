package eitr_tests

import "core:testing"

import "../"

@(test)
test_commands :: proc(t: ^testing.T) {
	testing.expect(t, eitr.command_matches("help", eitr.Commands.Help))
	testing.expect(t, eitr.command_matches("HELP", eitr.Commands.Help))
	testing.expect_value(
		t,
		eitr.command_matches("halp", eitr.Commands.Help),
		false,
	)
	testing.expect_value(
		t,
		eitr.command_matches("run", eitr.Commands.Help),
		false,
	)

	testing.expect(t, eitr.command_matches("init", eitr.Commands.Init))
	testing.expect(t, eitr.command_matches("config", eitr.Commands.Config))
	testing.expect(t, eitr.command_matches("run", eitr.Commands.Run))
}

@(test)
test_arguments :: proc(t: ^testing.T) {
	// --- Failures
	invalid_one, io_err := eitr.find_arg("-z")
	testing.expect(t, invalid_one == eitr.Arguments.Invalid)
	testing.expect(t, io_err == eitr.Eitr_Errors.Unknown_Argument)

	invalid_two, it_err := eitr.find_arg("--zebracakes")
	testing.expect(t, invalid_two == eitr.Arguments.Invalid)
	testing.expect(t, it_err == eitr.Eitr_Errors.Unknown_Argument)

	invalid_three, ithree_err := eitr.find_arg("--h")
	testing.expect(t, invalid_three == eitr.Arguments.Invalid)
	testing.expect(t, ithree_err == eitr.Eitr_Errors.Unknown_Argument)

	invalid_four, if_err := eitr.find_arg("-verbose")
	testing.expect(t, invalid_four == eitr.Arguments.Invalid)
	testing.expect(t, if_err == eitr.Eitr_Errors.Unknown_Argument)

	// --- Successes
	// Help
	valid_help, vho_err := eitr.find_arg("-h")
	testing.expect(t, valid_help == eitr.Arguments.Command_Help)
	testing.expect(t, vho_err == eitr.Eitr_Errors.None)

	valid_help_two, vht_err := eitr.find_arg("--help")
	testing.expect(t, valid_help_two == eitr.Arguments.Command_Help)
	testing.expect(t, vht_err == eitr.Eitr_Errors.None)

	// Verbose
	valid_verbose, vvo_err := eitr.find_arg("-v")
	testing.expect(t, valid_verbose == eitr.Arguments.Verbose)
	testing.expect(t, vvo_err == eitr.Eitr_Errors.None)

	valid_verbose_two, vvt_err := eitr.find_arg("--verbose")
	testing.expect(t, valid_verbose_two == eitr.Arguments.Verbose)
	testing.expect(t, vvt_err == eitr.Eitr_Errors.None)

	// Config
	valid_config, vco_err := eitr.find_arg("-c")
	testing.expect(t, valid_config == eitr.Arguments.Configuration)
	testing.expect(t, vco_err == eitr.Eitr_Errors.None)

	valid_config_two, vct_err := eitr.find_arg("--config")
	testing.expect(t, valid_config_two == eitr.Arguments.Configuration)
	testing.expect(t, vct_err == eitr.Eitr_Errors.None)

	// Output
	valid_output, voo_err := eitr.find_arg("-o")
	testing.expect(t, valid_output == eitr.Arguments.Output)
	testing.expect(t, voo_err == eitr.Eitr_Errors.None)

	valid_output_two, vot_err := eitr.find_arg("--output")
	testing.expect(t, valid_output_two == eitr.Arguments.Output)
	testing.expect(t, vot_err == eitr.Eitr_Errors.None)

	// Set
	valid_set, vso_err := eitr.find_arg("-s")
	testing.expect(t, valid_set == eitr.Arguments.Set)
	testing.expect(t, vso_err == eitr.Eitr_Errors.None)

	valid_set_two, vst_err := eitr.find_arg("--set")
	testing.expect(t, valid_set_two == eitr.Arguments.Set)
	testing.expect(t, vst_err == eitr.Eitr_Errors.None)

	// Directory
	valid_dir, vdo_err := eitr.find_arg("-d")
	testing.expect(t, valid_dir == eitr.Arguments.Scope_Directory)
	testing.expect(t, vdo_err == eitr.Eitr_Errors.None)

	valid_dir_two, vdt_err := eitr.find_arg("--directory")
	testing.expect(t, valid_dir_two == eitr.Arguments.Scope_Directory)
	testing.expect(t, vdt_err == eitr.Eitr_Errors.None)

	// Profile
	valid_profile, vpo_err := eitr.find_arg("-p")
	testing.expect(t, valid_profile == eitr.Arguments.Profile)
	testing.expect(t, vpo_err == eitr.Eitr_Errors.None)

	valid_profile_two, vpt_err := eitr.find_arg("--profile")
	testing.expect(t, valid_profile_two == eitr.Arguments.Profile)
	testing.expect(t, vpt_err == eitr.Eitr_Errors.None)

}
