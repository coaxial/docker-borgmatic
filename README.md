# Docker Borgmatic container

A docker container running [borgmatic](https://torsion.org/borgmatic/) to backup anything to anywhere.

# Usage

Put the data to backup at /var/backup on the docker host (will appear at /backup in the container)

Put the configuration files at borgmatic/ (ssh keys, borg keys, borgmatic config.yaml file, borg passphrase file, .jobber file...)

If you need inspiration, there is an example .jobber file at .jobber.example and an example borgmatic config file at config.example.yaml.
