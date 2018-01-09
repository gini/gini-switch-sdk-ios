#!/bin/bash

INFO_PLIST_PATH=$1
BUILD_NUMBER=$2

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "$INFO_PLIST_PATH"
