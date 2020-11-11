#!/bin/bash

set -eo pipefail

xcodebuild -project SCLAlertView.xcodeproj \
            -scheme SCLAlertView \
            -destination platform=iOS\ Simulator,OS=14.0,name=iPhone\ 11 \
            clean build | xcpretty
