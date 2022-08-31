
Feature: Basic

# The secrects can be used in the payload with the following syntax #(mysecretname)
Background:


Scenario: get request

	Given url karate.properties['testURL']

	And path '/'
	And header Direktiv-ActionID = 'development'
	And header Direktiv-TempDir = '/tmp'
	And request
	"""
	{
		"files": [
			{
			"name": "hosts",
			"data": "[myvirtualmachines]\nec2-52-59-26-1.eu-central-1.compute.amazonaws.com\n"

		}
		]
		,
		"commands": [
			{
			"command": "cat hosts",
			"silent": true,
			"print": false,
		},
			{
			"command": "env",
			"silent": true,
			"print": false,
		},
		{
			"command": "ansible all --list-hosts",
			"silent": true,
			"print": false,
		}
		]
	}
	"""
	When method POST
	Then status 200
	# And match $ ==
	# """
	# {
	# "ansible": [
	# {
	# 	"result": "#notnull",
	# 	"success": true
	# }
	# ]
	# }
	# """
	