{
	"targets": [{
		"target_name": "macIconForFile",
		"include_dirs": ["<!(node -e \"require('nan')\")"],
		"conditions": [[
			'OS=="mac"',
			{
				"sources": ["macIconForFile.mm"],
				"link_settings": {
					"libraries": ["-framework", "AppKit"]
				}
			}
		]]
	}]
}
