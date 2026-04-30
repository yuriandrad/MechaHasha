#!/usr/bin/env bash

# Detecta modo do hashcat por tamanho do hash.
detect_hash_mode() {
    local hash_value="$1"
    local len=${#hash_value}

    case "$len" in
        32) echo "0" ;;      # MD5
        40) echo "100" ;;    # SHA1
        64) echo "1400" ;;   # SHA256
        *) echo "" ;;
    esac
}

# Identificação automática com hashid (quando disponível).
detect_hash() {
    local hash_input="$1"

    if command -v hashid >/dev/null 2>&1; then
        hashid "$hash_input" 2>/dev/null
    else
        echo "hashid não encontrado. Instale para identificação avançada."
    fi
}
