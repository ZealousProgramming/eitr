package eitr

import "core:log"
import "core:strings"

Command_Kind :: enum {
	Invalid,
	Help,
	Init,
	Config,
	Run,
}

Command :: union {
	Help_Command,
	Init_Command,
	Config_Command,
	Run_Command,
}

Help_Command :: struct {
	_: bool,
}

Init_Command :: struct {
	configuration_path: Maybe(string),
}

Config_Command :: struct {
	display_configuration: bool,
	set_path:              bool,
	scope_directory:       bool,
}

Run_Command :: struct {
	profile: Maybe(string),
}


command_matches :: proc(text: string, cmd: Command_Kind) -> bool {
	if len(text) == 0 {return false}

	command_text: string

	switch cmd {
	case .Help:
		{
			command_text = "help"
		}
	case .Config:
		{
			command_text = "config"
		}
	case .Run:
		{
			command_text = "run"
		}
	case .Init:
		{
			command_text = "init"
		}
	case .Invalid:
		return false
	}

	return strings.to_lower(text, context.temp_allocator) == command_text
}

command_by_name :: proc(
	text: string,
	case_sensitive := false,
) -> (
	Command_Kind,
	Eitr_Errors,
) {
	if len(text) == 0 {return .Invalid, .Command_Not_Found}

	command_text :=
		!case_sensitive ? strings.to_lower(text, context.temp_allocator) : text

	switch command_text {
	case "help":
		return .Help, .None
	case "init":
		return .Init, .None
	case "config":
		return .Config, .None
	case "run":
		return .Run, .None
	}

	return .Invalid, .Command_Not_Found
}

//
find_command :: proc(
	args: []string,
	case_sensitive := false,
) -> (
	cmd: Command_Kind,
	err: Eitr_Errors,
) {
	if args == nil || len(args) <= 1 || args[1] == "" {
		return .Invalid, .Command_Not_Found
	}

	c, cbn_err := command_by_name(args[1], case_sensitive)

	return c, cbn_err
}


parse_command :: proc(
	args: []string,
	commands: ^[dynamic]^Command,
	allocator := context.allocator,
) -> Eitr_Errors {

	if len(args) <= 1 {
		log.error("[eitr] Command not found")
		return .Command_Not_Found
	}

	cmd, err := find_command(args)
	if err != .None {
		return err
	}

	switch cmd {
	case .Help:
		log.debug("[eitr] Found \"Help\" command")
		help := new(Help_Command, allocator)

		append(commands, cast(^Command)help)
	case .Init:
		log.debug("[eitr] Found \"Init\" command")
		init := new(Init_Command, allocator)

		append(commands, cast(^Command)init)
	case .Config:
		log.debug("[eitr] Found \"Config\" command")

		config := new(Config_Command, allocator)

		append(commands, cast(^Command)config)
	case .Run:
		log.debug("[eitr] Found \"Run\" command")
		run := new(Run_Command, allocator)

		profile_provided, profile_idx := contains_arg(args, .Profile, false)

		// Run the set default profile if not
		if profile_provided {
			if len(args) - 1 <= profile_idx {
				// No profile specified
				log.error("No input found for \"-p / --profle\"\n")
				return .Missing_Input
			}

			profile := args[profile_idx + 1]
			_, find_err := find_arg(profile, false)
			if find_err != .Unknown_Argument {
				log.errorf("%s is not valid input to -p/--profle\n", profile)
				return .Missing_Input
			}

			// TODO(devon): Check to see if it's a valid profile in eitr.json

			run.profile = profile
			log.debugf("Found profile: %v\n", run.profile)
		}

		// 

		append(commands, cast(^Command)run)
	case .Invalid:
		return .Unknown_Command
	}

	return .None
}
