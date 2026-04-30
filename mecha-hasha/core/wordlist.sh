#!/usr/bin/env bash
# seleção e validação de wordlist

choose_wordlist() {
  echo
  echo "Selecione a wordlist:"
  echo "[1] rockyou.txt"
  echo "[2] Caminho personalizado"
  read -rp "Opção: " option

  case "$option" in
    1)
      WORDLIST="wordlists/rockyou.txt"
      ;;
    2)
      read -rp "Informe o caminho da wordlist: " WORDLIST
      ;;
    *)
      error "Opção inválida."
      return 1
      ;;
  esac

  if ! validate_wordlist "$WORDLIST"; then
    error "Wordlist inexistente ou sem permissão de leitura: $WORDLIST"
    return 1
  fi

  success "Wordlist selecionada: $WORDLIST"
  return 0
}
