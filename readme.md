# Rancher Role

This role will setup a Rancher Management Cluster using the rke tool via ansible.

## Usage

Import the role using:

```shell
ansible-galaxy install -r requirements.yml
```

Playbook setup:

```yaml
roles:
- role: rancher
```

Requirements file:

```yaml
- src: https://bitbucket.foxsports.com.au/scm/ansible/rancher.git
  scm: git
  version: master
```

## Required Variables

The following variables need to be set when using this role:

```yaml
rancher_rke_ssh_private_key: |
    -----BEGIN OPENSSH PRIVATE KEY-----
      Some key here
      -----END OPENSSH PRIVATE KEY-----

rancher_host_list:
      - 10.0.0.101
      - 10.0.0.102
      - 10.0.0.103

rancher_environment: test

rancher_ingress_url: rancher-test.domain

```

## Optional Variables

The following are defaults that can be overridden:

```yaml
rancher_rke_version: v0.3.2
rancher_version: v2.3.2

rancher_rke_ssh_private_key_exists: yes
rancher_rke_ssh_private_key_fullpath: path/to/pre-existing/ssh/private/key


rancher_docker_registry_username: apro_username
rancher_docker_registry_password: apro_password

rancher_repo_user: apro_username
rancher_repo_pass: apro_password
```

## Testing

The role can be tested via vagrant using the following command:

```shell
vagrant up
```
