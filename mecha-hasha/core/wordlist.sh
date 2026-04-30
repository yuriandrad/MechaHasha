#!/usr/bin/env bash

choose_wordlist() {
    local default_wordlist="wordlists/rockyou.txt"

    echo "[1] Usar wordlist padrão (${default_wordlist})"
    echo "[2] Informar wordlist personalizada"
    read -rp "Escolha: " choice

    case "$choice" in
        1)
            if file_exists "$default_wordlist"; then
                CURRENT_WORDLIST="$default_wordlist"
                success "Wordlist padrão selecionada: $CURRENT_WORDLIST"
            else
                error "Wordlist padrão não encontrada em: $default_wordlist"
            fi
            ;;
        2)
            read -rp "Caminho da wordlist: " custom_wordlist
            if file_exists "$custom_wordlist"; then
                CURRENT_WORDLIST="$custom_wordlist"
                success "Wordlist selecionada: $CURRENT_WORDLIST"
            else
                error "Arquivo de wordlist inválido."
            fi
            ;;
        *)
            error "Opção inválida."
            ;;
    esac
}
