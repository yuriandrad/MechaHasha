#!/usr/bin/env bash
# utilitário de cores para saída no terminal

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() {
  echo -e "${GREEN}[+] $1${NC}"
}

error() {
  echo -e "${RED}[-] $1${NC}" >&2
}

info() {
  echo -e "${YELLOW}[*] $1${NC}"
}
