- Configurations
    - "name": "debug",
- Standardized `odinfmt.json` and `ols.json` for the entire system (for people like myself who use the same settings but have to copy it all over)
- Currently needs to utilize libc.system to run the odin command
- Maybe we can have directory-scoped configuration settings
    - Such as the output path, additional collections

How do I want to use it?
- `eitr init` 
- `eitr init -c ~/configs/odin/some-config.json`
- `eitr config`: config commands
- `eitr run` - runs with the set config for that directory (global by default unless otherwise set via `eitr config -set {PATH} -cwd`). The default profile is also used


## Commands
- `eitr [command] arguments`
    - `help`: Display the eitr commands
    - `run`: Run one of the profiles
        - `-p/--profile some_profile_name`: Select the profile to run
    - `init`: Setup directory with the `eitr.json` in the cwd. This will replace `odin-init`.
        - `-c {PATH}/some-config.json`: Initialize the directory with that configuration.
    - `config`: Configuration commands
        - `-o`: Prints the configuration for that cwd, defaults to the global.
        - `-set {PATH}`: Sets global config to the config file at the provided path
        - `-set {PATH} -cwd`: Sets the cwd's config file. Any `eitr` commands ran after will use the cached configuration file if it's called in this cwd.
        - `-w --where`: Prints out location of the working directory's eitr config resides
        - `-a --add-collection ${COLLECTION_NAME}=${COLLECTION_PATH}`: Add collection to the profile
        - `-r --remove-collection ${COLLECTION_NAME}`: Remove collection to the profile

-`eitr init`
-`[eitr] Executable output path(./bin/project-name): 
-`input`
- `Add any additional collections(Y/N)? 
- `input`
- `Collection name: `
- `input`
- `Collection path: `
- `input`
- `[eitr] correct? -collection:${COLLECTION_NAME}=${COLLECTION_PATH}`



- GET RUN TO WORK FIRST
    - Look for .eitr file in root
    - parse eitr file  
    - use the first profile found
    - build command from profile 
