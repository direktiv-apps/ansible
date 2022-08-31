
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
			"name": "ansible.cfg",
			"data": "[default]\nlocalhost"

		}
		]
		,
		"commands": [
		{
			"command": "ansible all -m ping",
			"silent": false,
			"print": true,
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
	