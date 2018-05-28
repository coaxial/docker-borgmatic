#!/bin/sh
exec with-contenv borgmatic -c /borgmatic/config.yaml 2>&1 | s6-log -v /var/log/borgmatic
