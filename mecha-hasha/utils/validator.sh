#!/usr/bin/env bash
# funções de validação de entrada/arquivos

validate_file_exists() {
  local file="$1"
  [[ -f "$file" ]]
}

validate_hash_hex() {
  local hash="$1"
  [[ "$hash" =~ ^[A-Fa-f0-9]+$ ]]
}

validate_wordlist() {
  local wordlist="$1"
  validate_file_exists "$wordlist" && [[ -r "$wordlist" ]]
}
