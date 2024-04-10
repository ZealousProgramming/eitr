# eitr
Eitr


```json
{
	"version": "0.0.1", // Versioning of te profile
	"configurations": [ // Build Configuration
		{
			"name": "debug",
            "command": "build", // Use the odin `build` command, or `run`
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
		},
        {
			"name": "release",
			"flags": [
                "-o:aggressive",
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
		"$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/odinfmt.schema.json",
		"character_width": 80,
		"tabs": true,
		"tabs_width": 4
	},
	"language-server": {
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
```