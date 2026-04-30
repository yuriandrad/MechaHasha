#!/usr/bin/env bash

# Shared utility functions for Mecha-Hasha CLI

readonly UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BASE_DIR="$(cd "$UTILS_DIR/.." && pwd)"
readonly LOG_FILE="$BASE_DIR/logs/mecha.log"
readonly RESULTS_DIR="$BASE_DIR/results"
readonly DB_FILE="$BASE_DIR/data/db/hashes.db"

# Ensure required directories/files are available.
init_environment() {
  mkdir -p "$BASE_DIR/logs" "$RESULTS_DIR"
  touch "$LOG_FILE"
  touch "$DB_FILE"
}

# Timestamp for logs and output files.
timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

# Log action messages.
log_action() {
  local message="$1"
  printf '[%s] %s\n' "$(timestamp)" "$message" >> "$LOG_FILE"
}

# Print user-friendly information.
info() {
  printf '[*] %s\n' "$1"
}

# Print success message.
success() {
  printf '[+] %s\n' "$1"
}

# Print error message.
error() {
  printf '[!] %s\n' "$1" >&2
}

# Require an executable binary to be installed.
require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    error "Required tool not found: $cmd"
    log_action "ERROR missing dependency: $cmd"
    return 1
  fi
}

# Validate menu choice as integer within a simple expected set.
validate_menu_choice() {
  local choice="$1"
  [[ "$choice" =~ ^[0-9]+$ ]]
}

# Validate hashcat mode as integer.
validate_hash_mode() {
  local mode="$1"
  [[ "$mode" =~ ^[0-9]+$ ]]
}

# Validate brute-force mask using a conservative character allowlist.
validate_mask() {
  local mask="$1"
  [[ "$mask" =~ ^[[:graph:]]+$ ]]
}

# Validate a hash string using hex plus common separators.
validate_hash_input() {
  local hash_input="$1"
  [[ "$hash_input" =~ ^[A-Fa-f0-9:$./-]+$ ]]
}

# Validate file path and ensure it points to an existing regular file.
validate_file_path() {
  local file_path="$1"
  [[ -n "$file_path" && -f "$file_path" ]]
}

# Create a safe output file path in results/.
result_file_path() {
  local prefix="$1"
  printf '%s/%s_%s.txt' "$RESULTS_DIR" "$prefix" "$(date '+%Y%m%d_%H%M%S')"
}
