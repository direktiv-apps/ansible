
# ansible 1.0

Run ansible in Direktiv

---
- #### Categories: build, infrastructure
- #### Image: gcr.io/direktiv/functions/ansible 
- #### License: [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0)
- #### Issue Tracking: https://github.com/direktiv-apps/ansible/issues
- #### URL: https://github.com/direktiv-apps/ansible
- #### Maintainer: [direktiv.io](https://www.direktiv.io) 
---

## About ansible

This function provides Ansible in Direktiv. Ansible version 2.13.3 is installed with the following modules:
- amazon.aws
- google.cloud
- azure.azcollection

The default configuration in `ansible.cfg` can be overwritten with either DirektivFiles or Direktiv variables.

*Default ansible.cfg*
``` [defaults]
inventory = hosts
host_key_checking = False
``` 

### Example(s)
  #### Function Configuration
```yaml
functions:
- id: ansible
  image: gcr.io/direktiv/functions/ansible:1.0
  type: knative-workflow
```
   #### Playbook with DirektivFiles
```yaml
- id: ansible
  type: action
  action:
    function: ansible
    input: 
      files: 
      - name: playbook.yaml
        data: |
          ---
          - name: "Ansible Playbook"
            hosts: localhost
            connection: local 
            tasks:
            - name: "ls on localhost"
              shell: "ls -l"
              register: "output"
      commands:
      - command: ansible-playbook playbook.yaml
```
   #### Playbook with variables
```yaml
- id: ansible
  type: action
  action:
    function: ansible
    files: 
    - key: playbook.yaml
      scope: workflow
    input:
      commands:
      - command: ansible-playbook playbook.yaml
```
   #### Custom ansible.cfg
```yaml
- id: ansible
  type: action
  action:
    function: ansible
    files: 
    - key: ansible.cfg
      scope: workflow
    input:
      commands:
      - command: ansible-config view
```

   ### Secrets


*No secrets required*







### Request



#### Request Attributes
[PostParamsBody](#post-params-body)

### Response
  List of executed commands.
#### Reponse Types
    
  

[PostOKBody](#post-o-k-body)
#### Example Reponses
    
```json
[
  {
    "result": {
      "custom_stats": {},
      "global_custom_stats": {},
      "plays": [
        {
          "play": {
            "duration": {
              "end": "2022-08-31T11:55:44.265820Z",
              "start": "2022-08-31T11:55:40.276975Z"
            },
            "id": "1ab65ae3-cbb9-49dc-b739-000000000005",
            "name": "Ansible Playbook"
          },
          "tasks": []
        }
      ]
    },
    "success": true
  },
  {
    "result": "[defaults]\ninventory = hosts\nhost_key_checking = False",
    "success": true
  }
]
```

### Errors
| Type | Description
|------|---------|
| io.direktiv.command.error | Command execution failed |
| io.direktiv.output.error | Template error for output generation of the service |
| io.direktiv.ri.error | Can not create information object from request |


### Types
#### <span id="post-o-k-body"></span> postOKBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| ansible | [][PostOKBodyAnsibleItems](#post-o-k-body-ansible-items)| `[]*PostOKBodyAnsibleItems` |  | |  |  |


#### <span id="post-o-k-body-ansible-items"></span> postOKBodyAnsibleItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| result | [interface{}](#interface)| `interface{}` | ✓ | |  |  |
| success | boolean| `bool` | ✓ | |  |  |


#### <span id="post-params-body"></span> postParamsBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| commands | [][PostParamsBodyCommandsItems](#post-params-body-commands-items)| `[]*PostParamsBodyCommandsItems` |  | `[{"command":"echo Hello"}]`| Array of commands. |  |
| files | [][DirektivFile](#direktiv-file)| `[]apps.DirektivFile` |  | | File to create before running commands. |  |


#### <span id="post-params-body-commands-items"></span> postParamsBodyCommandsItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| command | string| `string` |  | | Command to run |  |
| continue | boolean| `bool` |  | | Stops excecution if command fails, otherwise proceeds with next command |  |
| print | boolean| `bool` |  | `true`| If set to false the command will not print the full command with arguments to logs. |  |
| silent | boolean| `bool` |  | | If set to false the command will not print output to logs. |  |

 
