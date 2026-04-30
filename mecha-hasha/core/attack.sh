#!/usr/bin/env bash

run_attack() {
    local hash_source="$1"
    local hash_mode="$2"
    local output_file="output/results.txt"

    if [[ -z "$hash_source" ]]; then
        error "Nenhum hash carregado."
        return 1
    fi

    if [[ -z "$CURRENT_WORDLIST" ]]; then
        error "Nenhuma wordlist selecionada."
        return 1
    fi

    if ! file_exists "$CURRENT_WORDLIST"; then
        error "Wordlist inválida: $CURRENT_WORDLIST"
        return 1
    fi

    mkdir -p output

    if command -v hashcat >/dev/null 2>&1; then
        info "Ferramenta detectada: hashcat"
        info "Executando ataque de dicionário..."
        hashcat -a 0 -m "$hash_mode" "$hash_source" "$CURRENT_WORDLIST" --status --status-timer=5
        hashcat -m "$hash_mode" "$hash_source" --show | tee -a "$output_file"
        success "Resultado salvo em $output_file"
    elif command -v john >/dev/null 2>&1; then
        info "Ferramenta detectada: john"
        info "Executando ataque de dicionário..."
        john --wordlist="$CURRENT_WORDLIST" "$hash_source"
        john --show "$hash_source" | tee -a "$output_file"
        success "Resultado salvo em $output_file"
    else
        error "Nenhuma ferramenta encontrada. Instale hashcat ou john."
        return 1
    fi
}
