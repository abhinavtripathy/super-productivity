#!/bin/sh
set -eu

# The login is created at start from the environment so no default password
# ever ships in the image.
if [ -z "${WEBDAV_USERNAME:-}" ] || [ -z "${WEBDAV_PASSWORD:-}" ]; then
  echo "WEBDAV_USERNAME and WEBDAV_PASSWORD must be set" >&2
  exit 1
fi
htpasswd -bcB /usr/local/apache2/conf/webdav.htpasswd \
  "$WEBDAV_USERNAME" "$WEBDAV_PASSWORD" >/dev/null

# A fresh bind mount belongs to root; Apache writes as daemon.
chown daemon:daemon /data /dav-lock

exec "$@"
