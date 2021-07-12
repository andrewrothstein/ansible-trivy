andrewrothstein.trivy
=========
![Build Status](https://github.com/andrewrothstein/ansible-trivy/actions/workflows/build.yml/badge.svg)

Installs [trivy](https://github.com/aquasecurity/trivy) by Aqua Security

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.trivy
```

License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
