# eitr
Eitr

Only usable if you're lazy. Otherwise write `.sh` and `.bat` that handles the same thing.

## TODOs:
- Commands:
    - [ ] `help`
    - [ ] `init`
        - [ ] `--help`
        - [ ] `--verbose`
        - [ ] `--config`
    - [ ] `config`
        - [ ] `--help`
        - [ ] `--verbose`
        - [ ] `--output`
        - [ ] `--set`
        - [ ] `--directory`
    - [ ] `run`
        - [ ] `--help`
        - [ ] `--verbose`
        - [ ] `--profile`

## Configuration

```json
{
	"version": "0.0.1",
	"default-profile": "debug",
	"profiles": [
		{
			"name": "debug",
			"flags": [
				"-debug",
				"-vet",
				"-strict-style",
				"-show-timings"
			],
			"outputPath": "./bin/hogwash-game",
			"defines": [
				{
					"HOG_DEBUG": "true"
				},
				{
					"HOG_LOG_LEVEL": "info"
				}
			],
			"collections": [
				{
					"hogwash": "./src/hogwash"
				}
			]
		}
	],
	"formatter": {
		"odinfmt": {
			"$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/odinfmt.schema.json",
			"character_width": 80,
			"tabs": true,
			"tabs_width": 4
		}
	},
	"language-server": {
		"ols": {
			"collections": [
				{
					"name": "core",
					"path": "C:\\programming\\odin\\Odin\\core"
				},
				{
					"name": "vendor",
					"path": "C:\\programming\\odin\\Odin\\vendor"
				}
			],
			"enable_document_symbols": true,
			"enable_semantic_tokens": true,
			"enable_inlay_hints": true,
			"enable_procedure_snippet": true,
			"enable_hover": true,
			"enable_snippets": true,
			"enable_format": true,
			"formatter": {
				"tabs": true,
				"tabs_width": 4,
				"character_width": 80
			}
		}
	}
}
```