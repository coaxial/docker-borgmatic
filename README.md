# Docker Borgmatic service

`master`: [![Build Status](https://travis-ci.org/coaxial/docker-borgmatic.svg?branch=master)](https://travis-ci.org/coaxial/docker-borgmatic)

`snooze`: [![Build Status](https://travis-ci.org/coaxial/docker-borgmatic.svg?branch=snooze)](https://travis-ci.org/coaxial/docker-borgmatic)

A docker service running [borgmatic](https://torsion.org/borgmatic/) to backup anything to anywhere.

Leverages [borg](https://borgbackup.readthedocs.io/), [s6](http://skarnet.org/software/s6/index.html), and [s6-overlay](https://github.com/just-containers/s6-overlay)

# Variants

- the `master` branch uses [jobber](https://dshearer.github.io/jobber/) as a cron replacement (I'm keeping it around for backwards compatibility, some of my deployments still use it)
- the `snooze` branch uses [snooze](https://github.com/chneukirchen/snooze) as a cron replacement (best if you're starting from scratch: simpler to use and configure)

# Usage

The data to backup is expected to be at `/var/backup` on the host, and will appear at `/backup` within the container.

Add the required files (cf. below) at `borgmatic/` and run the container with `docker-compose up -d`.

See **Example** below for an Ansible playbook configuring this service as part of a mail server deployment.

# Required files

filename | purpose | notes
---|---|---
`ssh/known_hosts` | mounted at `/root/.ssh/known_hosts` to avoid ssh failing when first connecting to a host because key validation failed (mounted read only so that key changes are failures) | use `ssh-keyscan <hostname/ip>` to generate entries to paste in the file
`borgmatic/*` | mounted at `/borgmatic`, for any files required by jobber etc (more details below) |
`borgmatic/<ssh key{,.pub}>` | ssh keys used by borg/borgmatic/ssh |
`borgmatic/.jobber` | jobber file to execute (cf. https://dshearer.github.io/jobber/doc/v1.3/#jobfile) | see `.jobber.example`
`borgmatic/config.yaml` | borgmatic config file (cf. https://torsion.org/borgmatic/) | see `config.example.yaml`

# Volumes

mountpoint | purpose
`/borgmatic` | required files, cf. section above
`/cache` | borg cache if you want to persist it, cf. https://borgbackup.readthedocs.io/
`/var/log` | all logs, so they survive containers and so that other containers can access them
`/root/.ssh` | support for custom `known_hosts` file if needed

# Logging

For more details on how to setup logging, see [here](http://skarnet.org/software/s6/s6-log.html) and [there](https://github.com/just-containers/s6-overlay#logging). TLDR: create a `log/run` sh script to log to stdout.

# Example

See https://github.com/coaxial/ansible-role-mailcow/blob/master/tasks/borgmatic.yml for an Ansible task configuring the borgmatic container.

# Details

This project uses [s6](http://skarnet.org/software/s6/index.html) to manage services via [s6-overlay](https://github.com/just-containers/s6-overlay).

