package eitr

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

Help_Command :: struct {}

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

find_command :: proc(args: []string) -> (cmd: Command_Kind, err: Eitr_Errors) {
	if args == nil || len(args) <= 1 || args[1] == "" {
		return .Invalid, .Command_Not_Found
	}

	c, cbn_err := command_by_name(args[1])

	return c, cbn_err
}
