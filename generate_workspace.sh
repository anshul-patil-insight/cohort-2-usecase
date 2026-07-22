#!/usr/bin/env bash
set -euo pipefail

echo "Generating test workspace..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/Projects"

mkdir -p "$BASE_DIR"

for proj in WebApp API; do
    echo "Creating project $proj"
    mkdir -p "$BASE_DIR/$proj/src"
    mkdir -p "$BASE_DIR/$proj/docs"
    mkdir -p "$BASE_DIR/$proj/config"
    mkdir -p "$BASE_DIR/$proj/assets"

    printf 'SECRET_KEY=supersecret\n' > "$BASE_DIR/$proj/.env"
    printf '*.log\n' > "$BASE_DIR/$proj/.gitignore"

    printf "console.log('Hello World');\n" > "$BASE_DIR/$proj/src/index.js"
    printf '<h1>Welcome</h1>\n' > "$BASE_DIR/$proj/src/index.html"
    printf 'user=admin\n' > "$BASE_DIR/$proj/config/settings.conf"

    head -c 512 </dev/urandom > "$BASE_DIR/$proj/assets/icon.png" 2>/dev/null
    head -c 2048 </dev/urandom > "$BASE_DIR/$proj/assets/data.bin" 2>/dev/null
done

mkdir -p "$BASE_DIR/WebApp/empty_dir"

mkdir -p "$BASE_DIR/InaccessibleProject"
printf 'Top secret data.\n' > "$BASE_DIR/InaccessibleProject/secret.txt"
chmod 000 "$BASE_DIR/InaccessibleProject"
echo "Created inaccessible directory at $BASE_DIR/InaccessibleProject"

echo "Workspace generation complete."
