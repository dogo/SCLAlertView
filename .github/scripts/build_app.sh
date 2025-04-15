#!/bin/bash

set -eo pipefail

xcodebuild -project SCLAlertView.xcodeproj \
            -scheme SCLAlertView \
            -destination platform=iOS\ Simulator,OS=17.2,name=iPhone\ 15 \
            clean build | xcpretty
