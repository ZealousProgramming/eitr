package eitr

import "core:fmt"
import "core:os"

init_config :: proc() -> Eitr_Errors {
	has_eitr := os.exists("./eitr.json")
	// has_ols := os.exists("./ols.json")
	// has_odinfmt := os.exists("./odinfmt.json")

	if has_eitr {
		cwd := os.get_current_directory()
		fmt.eprintf(
			"[EITR][init_config] EITR configuration already exists at %s/eitr.json\n",
			cwd,
		)

		return .Configuration_Already_Exists
	}


	return .None
}

@(private = "file")
copy_default :: proc(source: string, destination: string) -> Eitr_Errors {
	src_fd, open_err := os.open(source)
	if open_err != 0 {
		fmt.eprintf(
			"[eitr][copy_default] Failed to open %s: %v",
			source,
			open_err,
		)

		return .IO_Error
	}

	data, read_success := os.read_entire_file_from_handle(
		src_fd,
		context.temp_allocator,
	)
	if !read_success {
		fmt.eprintf("[eitr] Failed to read %s", source)

		return .IO_Error
	}

	src_close_err := os.close(src_fd)
	if src_close_err != 0 {
		fmt.eprintf("[eitr] Failed to close %s: %v", source, src_close_err)

		return .IO_Error
	}

	write_success := os.write_entire_file(destination, data)
	if !write_success {
		fmt.eprintf("[eitr] Failed to copy %s to %s", source, destination)

		return .IO_Error
	}

	return .None
}
