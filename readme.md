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

```

## Optional Variables

The following are defaults that can be overridden:

```yaml

```

## Testing

The role can be tested via vagrant using the following command:

```shell
vagrant up
```
