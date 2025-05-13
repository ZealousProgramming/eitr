/*
		MIT License

		Copyright (c) 2024 Devon "ZealousProgramming" McKenzie

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
*/

package eitr

import "core:c/libc"
import "core:log"
import "core:os"

VERSION_MAJOR :: 0
VERSION_MINOR :: 1
VERSION_PATCH :: 0

VERBOSE := false
DEBUG := ODIN_DEBUG
LOG_LEVEL := log.Level.Warning

Eitr_Errors :: enum {
	None,
	Allocator_Failure,
	Command_Not_Found,
	Unknown_Command,
	Argument_Not_Found,
	Unknown_Argument,
	Missing_Input,
	Empty_Input,
	Configuration_Already_Exists,
	IO_Error,
}


main :: proc() {
	args: []string = os.args
	if len(args) <= 1 {
		log.errorf("Command required")
		os.exit(-1)
	}

	VERBOSE, _ = contains_arg(args, .Verbose, false)

	if (VERBOSE) {
		LOG_LEVEL = log.Level.Info
	}
	if (DEBUG) {
		LOG_LEVEL = log.Level.Debug
	}

	context.logger = log.create_console_logger(LOG_LEVEL)

	log.debug("Arguments provided: ")
	for arg in args {
		log.debugf("--- %v\n", arg)
	}

	cmds: [dynamic]^Command = make([dynamic]^Command)
	defer delete(cmds)

	parse_err := parse_command(args, &cmds)
	if parse_err != .None {
		// TODO(devon): Provide better error message
		// Should include where in the command it failed
		log.errorf("Failed to parse command: %s\n", parse_err)

		os.exit(-1)
	}

}

execute :: proc(cmd: string) {
	ret := libc.system("odin build -help")
	if ret != 0 {
		log.errorf("Failed to run \"odin build -help\": %v\n", ret)
	}
}
