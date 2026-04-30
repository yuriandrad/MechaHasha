#!/usr/bin/env bash

# Hash lookup module for Mecha-Hasha CLI.

run_lookup() {
  local hash_input result output_file

  echo "\n=== Lookup Mode ==="
  read -r -p "Enter hash to search: " hash_input

  if ! validate_hash_input "$hash_input"; then
    error "Invalid hash format."
    log_action "LOOKUP rejected invalid hash input"
    return 1
  fi

  log_action "LOOKUP query hash=$hash_input"
  output_file="$(result_file_path "lookup")"

  result="$(grep -F -- "${hash_input}:" "$DB_FILE" || true)"

  if [[ -n "$result" ]]; then
    printf '%s\n' "$result" | tee "$output_file"
    success "Hash found. Result saved to: $output_file"
    log_action "LOOKUP found hash=$hash_input output=$output_file"
  else
    printf 'No result found for hash: %s\n' "$hash_input" | tee "$output_file"
    info "Hash not found in local database."
    log_action "LOOKUP not-found hash=$hash_input output=$output_file"
  fi
}
