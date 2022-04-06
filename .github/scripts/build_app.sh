#!/bin/bash

set -eo pipefail

xcodebuild -project SCLAlertView.xcodeproj \
            -scheme SCLAlertView \
            -destination platform=iOS\ Simulator,OS=15.2,name=iPhone\ 11 \
            clean build | xcpretty
