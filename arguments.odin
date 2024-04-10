package eitr

import "core:fmt"
import "core:strings"

// odinfmt: disable
Arguments :: enum {
    Invalid,
    Command_Help,               // -h, --help
	Verbose,                    // -v, --verbose
	Configuration,              // -c, --config
	Output,                     // -o, --output     
	Set,                        // -s, --set
	Scope_Directory,            // -d, --directory
	Profile,                    // -p, --profile
}
// odinfmt: enable

contains_arg :: proc(cmd: string, arg: Arguments) -> bool {
	return false
}

find_arg :: proc(text: string) -> (arg: Arguments, err: Eitr_Errors) {
	if len(text) == 0 {return .Invalid, .Empty_Input}

	switch text {
	case "-h", "--help":
		return .Command_Help, .None
	case "-v", "--verbose":
		return .Verbose, .None
	case "-c", "--config":
		return .Configuration, .None
	case "-o", "--output":
		return .Output, .None
	case "-s", "--set":
		return .Set, .None
	case "-d", "--directory":
		return .Scope_Directory, .None
	case "-p", "--profile":
		return .Profile, .None

	case:
		fmt.eprintf("[eitr] ERROR: Unknown argument found - %v\n", text)
		return .Invalid, .Unknown_Argument
	}


}
