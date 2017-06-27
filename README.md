# ansible-template
a template ansible project to provide simple deployment for other projects

## Usage

### Clone the Project

From your project root, clone this project to the `ansible` directory
```
git clone https://github.com/inoc603/ansible-template.git ansible
```

You can delete git metadata in this project
```
rm -rf ansible/{.git,.gitignore}}
```

### Project layout

```
.
├── Makefile
├── defaults              // default value files
├── files                 // static files
├── inventory             // inventory files for different environment or stage
│   └── example.ini       // the template inventory file
├── roles                 // custom roles
├── templates             // jinja2 templates
├── test-playbook.yml     // an example playbook
└── vars                  // variable files for each environment
    ├── example.yml       // the template variable file
    └── secrets           // encrypted variable files
        └── example.yml   // the tempalte variable file encrypted with ansible vault
```

### Add New Environment

An environment `example` will have 3 files, `inventory/example.ini`,
`vars/example.yml`, `vars/secrets/example.yml`. To create a new environment
from an existing one, run:

```bash
make env tpl=example env=new-env
```

This will copy the 3 files of the `tpl` environment to `new-env`. You can then
modify inventory and var files of `new-env`.

### Add New Playbook

Playbooks should be placed under the project root. As in `test-playbook.yml`, 
any playbook should use the following variable files, where the variable
`inventory` is the name of the environment.

```yaml
vars_files:
  - "vars/{{ inventory }}.yml"
  - "vars/secrets/{{ inventory }}.yml"
```

### Managing Secret Values

Sensitive data in a play is encrypted with ansible vault, and stored in
`vars/secrets/*.yml`. You should put the password for ansible vault in file
`.vault.pass` in the project root. The default password is `pass`. To Change the
password, run `make rekey`, and echo the new password to `.vault.pass`.

To edit an encrypted var file, run:

```bash
make edit-secret env=example
```

### Run Playbook

To run a playbook, for example `test-playbook.yml`, run

```bash
make run/test-playbook
```
