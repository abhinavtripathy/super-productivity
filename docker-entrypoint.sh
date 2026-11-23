#!/bin/sh

# Set default port if not provided
: "${APP_PORT:=80}"
export APP_PORT

# nginx's template step only substitutes variables that are defined; an unset
# one would stay a literal "$WEBDAV_BACKEND" in the config.
: "${WEBDAV_BACKEND:=}"
export WEBDAV_BACKEND

# With a WebDAV backend behind the app's /webdav/ proxy, prefill the sync
# settings with that same-origin path unless a base URL is given.
if [ -n "${WEBDAV_BACKEND}" ] && [ -z "${WEBDAV_BASE_URL}" ]; then
  WEBDAV_BASE_URL=/webdav/
fi

# Generate ./assets/sync-config-default-override.json from environment variables
JSON="{}"
JSON_PATH=./assets/sync-config-default-override.json
if [ -n "${WEBDAV_BASE_URL}" ]; then
  JSON=$(echo "$JSON" | jq ".webDav.baseUrl |= \"$WEBDAV_BASE_URL\"")
fi
if [ -n "${WEBDAV_USERNAME}" ]; then
  JSON=$(echo "$JSON" | jq ".webDav.userName |= \"$WEBDAV_USERNAME\"")
fi
if [ -n "${WEBDAV_SYNC_FOLDER_PATH}" ]; then
  JSON=$(echo "$JSON" | jq ".webDav.syncFolderPath |= \"$WEBDAV_SYNC_FOLDER_PATH\"")
fi
if [ "$JSON" != "{}" ]; then
  # Change syncProvider if previous variables are set
  JSON=$(echo "$JSON" | jq '.syncProvider |= "WebDAV"')
fi
if [ -n "${SYNC_INTERVAL}" ]; then
  JSON=$(echo "$JSON" | jq ".syncInterval |= $(expr $SYNC_INTERVAL \* 60000)")
fi
if [ -n "${IS_COMPRESSION_ENABLED}" ]; then
  JSON=$(echo "$JSON" | jq ".isCompressionEnabled |= $IS_COMPRESSION_ENABLED")
fi
if [ -n "${IS_ENCRYPTION_ENABLED}" ]; then
  JSON=$(echo "$JSON" | jq ".isEncryptionEnabled |= $IS_ENCRYPTION_ENABLED")
fi
if [ "$JSON" != "{}" ]; then
  # Write the resultant json
  echo "$JSON" >$JSON_PATH
fi

# go back to nginx's built-in entrypoint script
exec /docker-entrypoint.sh nginx -g "daemon off;"
