#! /usr/bin/env bash

set -e

# see https://stackoverflow.com/a/246128/5354298
get_script_dir() { cd "$( dirname "${BASH_SOURCE[0]}" )"; echo "$( pwd )"; }

# see https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
is_installed() { hash $1 2>/dev/null || { false; } }
exit_if_not_installed() { is_installed $1 || { echo >&2 "I require $1 but it's not installed. Aborting. See https://nixos.org/nix/manual/#sec-prerequisites-source."; exit 1; } }
function ensure_installed() {
	if ! is_installed $1 ; then
		echo "Installing missing dependency $1...";
		$2;
	fi
}

SCRIPT_DIR="$(get_script_dir)"

echo "installing/updating pvjs"

echo "ensuring nix is installed and up to date...";
exit_if_not_installed nix-channel;
exit_if_not_installed nix-env;
nix-channel --update

ensure_installed node "nix-env -f <nixpkgs> -i nodejs";
ensure_installed node2nix "nix-env -f <nixpkgs> -iA nodePackages.node2nix";

cd "$SCRIPT_DIR";

rm -f default.nix node-packages.nix node-env.nix;

node2nix --flatten -6 -i "$SCRIPT_DIR/node-packages.json"
nix-env -f default.nix -i
