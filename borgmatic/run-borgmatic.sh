#!/usr/bin/with-contenv sh
# shellcheck shell=sh
exec borgmatic -c /borgmatic/config.yaml 2>&1 | s6-log -v /var/log/borgmatic
