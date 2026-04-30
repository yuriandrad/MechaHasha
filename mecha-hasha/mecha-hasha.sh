#!/usr/bin/env bash
# Mecha-Hasha - ferramenta educacional para identificação e quebra de hashes

set -u

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_HASH_FILE="$BASE_DIR/.tmp_hashes.txt"
RESULTS_FILE="$BASE_DIR/output/results.txt"
WORDLIST=""

# shellcheck source=utils/colors.sh
source "$BASE_DIR/utils/colors.sh"
# shellcheck source=utils/validator.sh
source "$BASE_DIR/utils/validator.sh"
# shellcheck source=core/hash_detect.sh
source "$BASE_DIR/core/hash_detect.sh"
# shellcheck source=core/wordlist.sh
source "$BASE_DIR/core/wordlist.sh"
# shellcheck source=core/attack.sh
source "$BASE_DIR/core/attack.sh"

cleanup() {
  rm -f "$TEMP_HASH_FILE"
}

trap cleanup EXIT

input_hash() {
  read -rp "Digite o hash: " user_hash
  user_hash="$(echo "$user_hash" | tr -d '[:space:]')"

  if [[ -z "$user_hash" ]]; then
    error "Hash vazio."
    return 1
  fi

  if ! validate_hash_hex "$user_hash"; then
    error "Hash inválido. Use apenas caracteres hexadecimais."
    return 1
  fi

  echo "$user_hash" > "$TEMP_HASH_FILE"
  success "Hash armazenado temporariamente."
}

load_hash_file() {
  read -rp "Informe o caminho do arquivo com hashes: " hash_file

  if ! validate_file_exists "$hash_file"; then
    error "Arquivo não encontrado: $hash_file"
    return 1
  fi

  cp "$hash_file" "$TEMP_HASH_FILE"
  success "Arquivo de hashes carregado."
}

identify_hash_menu() {
  if [[ ! -s "$TEMP_HASH_FILE" ]]; then
    error "Nenhum hash carregado para identificar."
    return 1
  fi

  local sample_hash
  sample_hash="$(head -n 1 "$TEMP_HASH_FILE" | tr -d '\r\n')"

  if ! validate_hash_hex "$sample_hash"; then
    error "O hash carregado parece inválido para detecção automática."
    return 1
  fi

  detect_hash "$sample_hash"
}

show_menu() {
  echo
  echo "========== Mecha-Hasha =========="
  echo "[1] Inserir hash"
  echo "[2] Carregar arquivo"
  echo "[3] Identificar hash"
  echo "[4] Escolher wordlist"
  echo "[5] Executar ataque"
  echo "[6] Sair"
  echo "================================="
}

main() {
  mkdir -p "$BASE_DIR/output"
  touch "$RESULTS_FILE"

  while true; do
    show_menu
    read -rp "Escolha uma opção: " choice

    case "$choice" in
      1) input_hash ;;
      2) load_hash_file ;;
      3) identify_hash_menu ;;
      4) choose_wordlist ;;
      5) run_attack ;;
      6)
        info "Saindo do Mecha-Hasha."
        break
        ;;
      *)
        error "Opção inválida. Tente novamente."
        ;;
    esac
  done
}

main
