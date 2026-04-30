#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=modules/utils.sh
source "$SCRIPT_DIR/modules/utils.sh"
# shellcheck source=modules/recovery.sh
source "$SCRIPT_DIR/modules/recovery.sh"
# shellcheck source=modules/lookup.sh
source "$SCRIPT_DIR/modules/lookup.sh"

main_menu() {
  local option

  init_environment
  log_action "Mecha-Hasha CLI started"

  while true; do
    echo "\n==== Mecha-Hasha CLI ===="
    echo "1 - Recovery (Cracking)"
    echo "2 - Lookup (Search hash)"
    echo "0 - Exit"
    read -r -p "Choose an option: " option

    if ! validate_menu_choice "$option"; then
      error "Invalid input. Enter a numeric option."
      continue
    fi

    case "$option" in
      1)
        run_recovery || true
        ;;
      2)
        run_lookup || true
        ;;
      0)
        log_action "Mecha-Hasha CLI exited"
        success "Goodbye."
        exit 0
        ;;
      *)
        error "Invalid option."
        ;;
    esac
  done
}

main_menu
