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
import "core:fmt"
import "core:os"

VERSION_MAJOR := 1
VERSION_MINOR := 1
VERSION_PATCH := 0

Eitr_Errors :: enum {
	None,
	Allocator_Failure,
	Command_Not_Found,
	Unknown_Command,
	Argument_Not_Found,
	Unknown_Argument,
	Missing_Input,
	Empty_Input,
}

main :: proc() {
	fmt.println("[eitr] Provided arguments: ")

	args: []string = os.args

	for arg in args {
		fmt.println(arg)
	}


}

execute_command :: proc(cmd: string) {
	ret := libc.system("odin build -help")
	if ret != 0 {
		fmt.eprintf(
			"[eitr] Error occured running \"odin build -help\": %v\n",
			ret,
		)
	}
}
