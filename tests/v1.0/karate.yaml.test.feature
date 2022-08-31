
Feature: Basic

# The secrects can be used in the payload with the following syntax #(mysecretname)
Background:


Scenario: version

	Given url karate.properties['testURL']

	And path '/'
	And header Direktiv-ActionID = 'development'
	And header Direktiv-TempDir = '/tmp'
	And request
	"""
	{
		"commands": [
		{
			"command": "ansible --version",
			"silent": false,
			"print": true,
		}
		]
	}
	"""
	When method POST
	Then status 200
	And match $ ==
	"""
	{
	"ansible": [
	{
		"result": "#notnull",
		"success": true
	}
	]
	}
	"""
	
	Scenario: listhosts

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
			"command": "ansible all --list-hosts",
			"silent": false,
			"print": true,
		}
		]
	}
	"""
	When method POST
	Then status 200
	And match $ ==
	"""
	{
	"ansible": [
	{
		"result": "#notnull",
		"success": true
	}
	]
	}
	"""
	
	Scenario: playbook

	Given url karate.properties['testURL']

	And path '/'
	And header Direktiv-ActionID = 'development'
	And header Direktiv-TempDir = '/tmp'
	And request
	"""
	{
		"files": [
			{
			"name": "playbook.yaml",
			"data": "---\n- name: \"Ansible Playbook\"\n  hosts: localhost\n  connection: local\n  tasks:\n  - name: \"ls on localhost\"\n    shell: \"ls -l\"\n    register: \"output\"\n"
		}
		]
		,
		"commands": [
		{
			"command": "ansible-playbook playbook.yaml",
			"silent": false,
			"print": true,
		}
		]
	}
	"""
	When method POST
	Then status 200
	And match $ ==
	"""
	{
	"ansible": [
	{
		"result": "#notnull",
		"success": true
	}
	]
	}
	"""
	