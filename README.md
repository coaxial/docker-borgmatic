# Docker Borgmatic service

A docker service running [borgmatic](https://torsion.org/borgmatic/) to backup anything to anywhere.

Leverages [borg](https://borgbackup.readthedocs.io/), [s6](http://skarnet.org/software/s6/index.html), and [s6-overlay](https://github.com/just-containers/s6-overlay)

## Variants

- the `master` branch uses [jobber](https://dshearer.github.io/jobber/) as a cron replacement
- the `snooze` branch uses [snooze](https://github.com/chneukirchen/snooze) as a cron replacement

## Usage

### Borgmatic's config.yaml file

Borgmatic will look for its `config.yaml` file in the `borgmatic/` directory. See the `config.yaml.example` file for inspiration and `config.full.yaml.example` for every available option.

### Before, on success, on fail hooks

The example Borgmatic config file uses before-backup, after-backup, and failed-backup scripts. They provide a convenient mechanism for preparing the backups, cleaning up after them, and handling failures. They are only here for inspiration, but they're not required; it depends on what is in you `config.yaml` file. The path must be absolute, anything in `borgmatic/` is mounted as `/borgmatic/` within the container.

### ssh keys and known_hosts file

To avoid borg prompting for a password or to accept the SSH fingerprint, the files at `ssh/` will be mounted at `/root/.ssh` in the container. You most likely want your `id_rsa{,pub}` and `known_hosts` files in there. To generate the `known_hosts` file, you can either use `ssh-keyscan` or ssh to the remote server within a temporary container and look at the resulting `known_hosts` file.

# Volumes

mountpoint | purpose
`/borgmatic` | required files, cf. section above
`/cache` | borg cache if you want to persist it, cf. https://borgbackup.readthedocs.io/
`/root/.ssh` | share ssh keys and known_hosts file with container

# Logging

For more details on how to setup logging, see [here](http://skarnet.org/software/s6/s6-log.html) and [there](https://github.com/just-containers/s6-overlay#logging). TLDR: create a `root/etc/services.d/borgmatic/log/run` sh script to log to stdout.

# Examples

- See https://github.com/coaxial/ansible-role-mailcow/blob/master/tasks/borgmatic.yml for an Ansible task using the jobber version of this service.

- See https://github.com/coaxial/ansible-role-taskd/ for an Ansible role using the snooze version of this service.
