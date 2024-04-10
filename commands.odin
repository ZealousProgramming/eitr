package eitr

import "core:strings"

Commands :: enum {
	Help,
	Init,
	Config,
	Run,
}

command_matches :: proc(text: string, cmd: Commands) -> bool {
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
	}

	return strings.to_lower(text, context.temp_allocator) == command_text
}
