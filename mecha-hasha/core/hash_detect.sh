#!/usr/bin/env bash
# detecção do tipo de hash usando hashid e heurística de tamanho

detect_hash_mode() {
  local hash="$1"
  case ${#hash} in
    32) echo "0" ;;     # MD5
    40) echo "100" ;;   # SHA1
    64) echo "1400" ;;  # SHA256
    *) echo "" ;;
  esac
}

detect_hash() {
  local hash="$1"

  if command -v hashid >/dev/null 2>&1; then
    info "Possíveis tipos detectados pelo hashid:"
    hashid "$hash" | sed '1d'
  else
    info "hashid não está instalado. Exibindo detecção por tamanho."
  fi

  local mode
  mode="$(detect_hash_mode "$hash")"

  if [[ -n "$mode" ]]; then
    info "Modo sugerido para hashcat: $mode"
  else
    error "Não foi possível sugerir modo automaticamente para este hash."
  fi
}
