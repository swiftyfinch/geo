#!/bin/bash

success() {
	printf "\e[32m$1\e[m\n"
}
error() {
	printf "\e[31m$1\e[m\n"
}
warning() {
	printf "\e[33m$1\e[m\n"
}

if command -v geo &> /dev/null; then
	warning "🐚 geo has already been installed."; exit
fi

# Get the current machine architecture
if [[ `arch` = arm64* ]]; then
	ARCH='arm64'
else
	ARCH='x86_64'
fi

# Download the latest geo version for the current machine architecture
GEO_DOWNLOADS="$HOME/.geo/downloads"
GEO_BIN_PATH="$HOME/.local/bin"
rm -rf "$GEO_DOWNLOADS/downloads" && mkdir -p "$GEO_DOWNLOADS/downloads" && cd "$GEO_DOWNLOADS/downloads"
curl -sSLO "https://github.com/swiftyfinch/geo/releases/latest/download/$ARCH.zip"
unzip -q "$ARCH.zip"
mkdir -p $GEO_BIN_PATH
cp geo $GEO_BIN_PATH && rm -rf "$GEO_DOWNLOADS/downloads"
success "🐚 geo has been installed ✓"

# Check if geo is in $PATH
if [[ ":${PATH}:" != *":$GEO_BIN_PATH:"* ]]; then
	error "\n$GEO_BIN_PATH is not in your \$PATH"
	warning "Add it manually to your shell profile."
	warning "For example, if you use zsh, run this command:"
	echo "\$ echo '\nexport PATH=\$PATH:~/.local/bin' >> ~/.zshrc"
	warning "Than open a new window or tab in the terminal for applying changes."
fi
