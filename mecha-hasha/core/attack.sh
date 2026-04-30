#!/usr/bin/env bash
# execução do ataque com hashcat (preferencial) e fallback para john

run_attack() {
  if [[ ! -f "$TEMP_HASH_FILE" ]] || [[ ! -s "$TEMP_HASH_FILE" ]]; then
    error "Nenhum hash carregado. Use as opções [1] ou [2] primeiro."
    return 1
  fi

  if [[ -z "$WORDLIST" ]]; then
    error "Nenhuma wordlist selecionada. Use a opção [4]."
    return 1
  fi

  if ! validate_wordlist "$WORDLIST"; then
    error "Wordlist inválida: $WORDLIST"
    return 1
  fi

  local first_hash hash_mode tool
  first_hash="$(head -n 1 "$TEMP_HASH_FILE" | tr -d '\r\n')"
  hash_mode="$(detect_hash_mode "$first_hash")"

  if command -v hashcat >/dev/null 2>&1; then
    tool="hashcat"
  elif command -v john >/dev/null 2>&1; then
    tool="john"
  else
    error "Nem hashcat nem john foram encontrados no sistema."
    return 1
  fi

  info "Ferramenta selecionada: $tool"

  if [[ "$tool" == "hashcat" ]]; then
    if [[ -z "$hash_mode" ]]; then
      error "Hash não suportado para modo automático. Selecione outro hash (MD5/SHA1/SHA256)."
      return 1
    fi

    info "Executando ataque de dicionário com hashcat (mode $hash_mode)..."
    hashcat -a 0 -m "$hash_mode" "$TEMP_HASH_FILE" "$WORDLIST" --force

    local cracked
    cracked="$(hashcat -m "$hash_mode" "$TEMP_HASH_FILE" --show 2>/dev/null)"

    if [[ -n "$cracked" ]]; then
      success "Hash(es) quebrado(s) com sucesso!"
      echo "$cracked" | tee -a "$RESULTS_FILE"
      success "Resultados salvos em: $RESULTS_FILE"
    else
      info "Nenhum resultado encontrado até o momento."
    fi
  else
    info "Executando ataque de dicionário com john (fallback)..."
    john --wordlist="$WORDLIST" "$TEMP_HASH_FILE"

    local cracked
    cracked="$(john --show "$TEMP_HASH_FILE" 2>/dev/null | sed '/^\s*$/d')"

    if [[ -n "$cracked" ]]; then
      success "Resultado(s) retornado(s) pelo john!"
      echo "$cracked" | tee -a "$RESULTS_FILE"
      success "Resultados salvos em: $RESULTS_FILE"
    else
      info "Nenhum resultado encontrado até o momento."
    fi
  fi
}
