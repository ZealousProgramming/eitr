package eitr

import "core:fmt"
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
		fmt.eprintln("[eitr] Command not found")
		return .Command_Not_Found
	}

	// Skip the .exe arg
	// idx := 1

	cmd, err := find_command(args)
	if err != .None {
		return err
	}

	switch cmd {
	case .Help:
		fmt.println("[eitr] Found \"Help\" command")
		help := new(Help_Command, allocator)

		append(commands, cast(^Command)help)
	case .Init:
		fmt.println("[eitr] Found \"Init\" command")
		init := new(Init_Command, allocator)

		append(commands, cast(^Command)init)
	case .Config:
		fmt.println("[eitr] Found \"Config\" command")

		config := new(Config_Command, allocator)

		append(commands, cast(^Command)config)
	case .Run:
		fmt.println("[eitr] Found \"Run\" command")
		run := new(Run_Command, allocator)

		append(commands, cast(^Command)run)
	case .Invalid:
		return .Unknown_Command
	}

	return .None
}
