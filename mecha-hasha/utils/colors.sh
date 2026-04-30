#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}[+] $*${NC}"; }
error() { echo -e "${RED}[-] $*${NC}"; }
info() { echo -e "${YELLOW}[*] $*${NC}"; }
