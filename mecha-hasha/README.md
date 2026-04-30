# Mecha-Hasha

Mecha-Hasha é uma ferramenta CLI em Bash para **identificação de hashes** e **ataque de dicionário** com foco educacional e uso em auditorias autorizadas.

## Funcionalidades

- Entrada de hash manual
- Carregamento de arquivo com hashes
- Identificação de tipo de hash via `hashid`
- Sugestão automática de modo hashcat:
  - 32 chars -> MD5 (`-m 0`)
  - 40 chars -> SHA1 (`-m 100`)
  - 64 chars -> SHA256 (`-m 1400`)
- Seleção de wordlist (`rockyou.txt` ou caminho personalizado)
- Ataque com `hashcat` (preferencial)
- Fallback automático para `john` quando `hashcat` não estiver disponível
- Salvamento dos resultados em `output/results.txt`

## Dependências

Instale as dependências abaixo:

### Debian/Ubuntu/Kali

```bash
sudo apt update
sudo apt install -y hashcat john hashid
```

## Execução

No diretório do projeto:

```bash
chmod +x mecha-hasha.sh
./mecha-hasha.sh
```

## Menu interativo

```text
[1] Inserir hash
[2] Carregar arquivo
[3] Identificar hash
[4] Escolher wordlist
[5] Executar ataque
[6] Sair
```

## Exemplo de uso rápido

1. Escolha `[1]` e informe um hash.
2. Escolha `[3]` para identificar o tipo.
3. Escolha `[4]` e selecione a wordlist.
4. Escolha `[5]` para iniciar o ataque.
5. Consulte `output/results.txt` para ver os resultados.

## Aviso ético e legal

Esta ferramenta deve ser usada **somente** em ambientes autorizados, para fins de estudo, laboratório e auditorias com permissão explícita. O uso indevido pode violar leis locais e internacionais.
