#!/bin/bash

HOCKEYAPP_ID=$1
HOCKEYAPP_KEY=$2
INFO_PLIST_PATH=$3

hockeyLastBuildNumber=$(curl -H "X-HockeyAppToken: $HOCKEYAPP_KEY" https://rink.hockeyapp.net/api/2/apps/$HOCKEYAPP_ID/app_versions | python -c "import sys, json; print json.load(sys.stdin)['app_versions'][0]['version']")

#Build number bump
buildNumber=$(($hockeyLastBuildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFO_PLIST_PATH"
