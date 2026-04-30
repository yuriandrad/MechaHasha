#!/usr/bin/env bash

# Recovery mode (hash cracking) module for Mecha-Hasha CLI.

run_recovery() {
  local tool_choice attack_choice hash_file wordlist mode mask output_file

  echo "\n=== Recovery Mode ==="
  echo "Choose tool:"
  echo "1 - hashcat"
  echo "2 - john"
  read -r -p "Tool option: " tool_choice

  if ! validate_menu_choice "$tool_choice"; then
    error "Invalid tool option."
    return 1
  fi

  case "$tool_choice" in
    1)
      require_command "hashcat" || return 1
      ;;
    2)
      require_command "john" || return 1
      ;;
    *)
      error "Unsupported tool option."
      return 1
      ;;
  esac

  read -r -p "Enter hash file path: " hash_file
  if ! validate_file_path "$hash_file"; then
    error "Invalid hash file path."
    return 1
  fi

  echo "Choose attack type:"
  echo "1 - dictionary"
  echo "2 - brute force (mask)"
  read -r -p "Attack option: " attack_choice

  if ! validate_menu_choice "$attack_choice"; then
    error "Invalid attack option."
    return 1
  fi

  output_file="$(result_file_path "recovery")"

  case "$tool_choice" in
    1)
      read -r -p "Enter hash mode (-m value, numeric): " mode
      if ! validate_hash_mode "$mode"; then
        error "Invalid hash mode."
        return 1
      fi

      case "$attack_choice" in
        1)
          read -r -p "Enter wordlist path: " wordlist
          if ! validate_file_path "$wordlist"; then
            error "Invalid wordlist path."
            return 1
          fi
          log_action "RECOVERY hashcat dictionary mode=$mode hashfile=$hash_file wordlist=$wordlist"
          hashcat -a 0 -m "$mode" "$hash_file" "$wordlist" | tee "$output_file"
          ;;
        2)
          read -r -p "Enter brute-force mask (example: ?a?a?a?a): " mask
          if ! validate_mask "$mask"; then
            error "Invalid mask format."
            return 1
          fi
          log_action "RECOVERY hashcat mask mode=$mode hashfile=$hash_file mask=$mask"
          hashcat -a 3 -m "$mode" "$hash_file" "$mask" | tee "$output_file"
          ;;
        *)
          error "Unsupported attack option."
          return 1
          ;;
      esac
      ;;
    2)
      case "$attack_choice" in
        1)
          read -r -p "Enter wordlist path: " wordlist
          if ! validate_file_path "$wordlist"; then
            error "Invalid wordlist path."
            return 1
          fi
          log_action "RECOVERY john dictionary hashfile=$hash_file wordlist=$wordlist"
          john --wordlist="$wordlist" "$hash_file" | tee "$output_file"
          ;;
        2)
          read -r -p "Enter brute-force mask (john mask syntax): " mask
          if ! validate_mask "$mask"; then
            error "Invalid mask format."
            return 1
          fi
          log_action "RECOVERY john mask hashfile=$hash_file mask=$mask"
          john --mask="$mask" "$hash_file" | tee "$output_file"
          ;;
        *)
          error "Unsupported attack option."
          return 1
          ;;
      esac
      ;;
  esac

  success "Recovery operation finished. Output saved to: $output_file"
  log_action "RECOVERY completed output=$output_file"
}
