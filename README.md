# Docker Borgmatic container

A docker container running [borgmatic](https://torsion.org/borgmatic/) to backup anything to anywhere.

# Usage

Copy the config.example.yaml to config.yaml and edit it to suit your needs.

Mount the data to backup at `/backups` (use subdirs if needed).

Add your ssh key as `ssh.key`
TODO: figure out ssh key and repo keys usage (probably as files to be mounted in?)
