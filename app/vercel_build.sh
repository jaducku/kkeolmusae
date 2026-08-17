#!/bin/bash
set -euo pipefail

git clone https://github.com/flutter/flutter.git -b stable --depth 1 flutter_sdk
export PATH="$PATH:$(pwd)/flutter_sdk/bin"

flutter doctor -v
flutter pub get
flutter build web --release
