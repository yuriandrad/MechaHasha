#!/usr/bin/env bash

set -u

source "utils/colors.sh"
source "utils/validator.sh"
source "core/hash_detect.sh"
source "core/wordlist.sh"
source "core/attack.sh"

CURRENT_HASH=""
HASH_FILE=""
CURRENT_WORDLIST=""
HASH_MODE=""

input_hash() {
    read -rp "Digite o hash: " user_hash
    if [[ -z "$user_hash" ]]; then
        error "Hash vazio."
        return
    fi
    CURRENT_HASH="$user_hash"
    HASH_FILE="output/single_hash.txt"
    mkdir -p output
    echo "$CURRENT_HASH" > "$HASH_FILE"
    success "Hash carregado com sucesso."
}

load_hash_file() {
    read -rp "Caminho do arquivo de hashes: " input_file
    if file_exists "$input_file"; then
        HASH_FILE="$input_file"
        CURRENT_HASH="$(head -n 1 "$input_file")"
        success "Arquivo carregado: $HASH_FILE"
    else
        error "Arquivo não encontrado."
    fi
}

identify_hash() {
    if [[ -z "$CURRENT_HASH" ]]; then
        error "Nenhum hash carregado para identificar."
        return
    fi

    info "Possíveis tipos detectados via hashid:"
    detect_hash "$CURRENT_HASH"

    HASH_MODE="$(detect_hash_mode "$CURRENT_HASH")"
    if [[ -n "$HASH_MODE" ]]; then
        info "Modo sugerido (por tamanho): $HASH_MODE"
    else
        error "Não foi possível detectar modo por tamanho do hash."
    fi

    read -rp "Deseja informar manualmente o modo do hashcat? (s/N): " manual_mode
    if [[ "$manual_mode" =~ ^[sS]$ ]]; then
        read -rp "Digite o modo do hashcat (ex: 0,100,1400): " selected_mode
        HASH_MODE="$selected_mode"
        success "Modo definido manualmente: $HASH_MODE"
    fi
}

execute_attack() {
    if [[ -z "$HASH_FILE" ]]; then
        error "Nenhum hash carregado. Use opção [1] ou [2]."
        return
    fi

    if [[ -z "$HASH_MODE" ]]; then
        info "Modo não definido. Tentando detectar automaticamente..."
        HASH_MODE="$(detect_hash_mode "$CURRENT_HASH")"
    fi

    if [[ -z "$HASH_MODE" ]]; then
        error "Modo do hash indefinido. Execute a identificação primeiro."
        return
    fi

    run_attack "$HASH_FILE" "$HASH_MODE"
}

show_menu() {
    echo
    echo "===== Mecha-Hasha ====="
    echo "[1] Inserir hash manual"
    echo "[2] Carregar arquivo de hashes"
    echo "[3] Identificar tipo de hash"
    echo "[4] Escolher wordlist"
    echo "[5] Executar ataque"
    echo "[6] Sair"
    echo
}

main() {
    while true; do
        show_menu
        read -rp "Escolha uma opção: " option

        case "$option" in
            1) input_hash ;;
            2) load_hash_file ;;
            3) identify_hash ;;
            4) choose_wordlist ;;
            5) execute_attack ;;
            6) success "Saindo..."; break ;;
            *) error "Opção inválida." ;;
        esac
    done
}

main
