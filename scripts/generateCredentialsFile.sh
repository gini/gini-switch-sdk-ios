#!/bin/bash

# This script takes the client credentials as the first, second and third command line
# argument (respectively) and generates a Credentials.plist file in the proper
# format that will be used during the build process to inject the values.
# The script also takes a forth parameter, specifying the destination the file
# will be saved to

CLIENT_ID=$1
CLIENT_SECRET=$2
CLIENT_DOMAIN=$3
DEST_FILE=$4

printf '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>ClientID</key>
    <string>'$CLIENT_ID'</string>
    <key>ClientSecret</key>
    <string>'$CLIENT_SECRET'</string>
    <key>ClientDomain</key>
    <string>'$CLIENT_DOMAIN'</string>
  </dict>
</plist>' > $DEST_FILE
