# Mecha-Hasha

Ferramenta educacional em Bash para identificação e quebra de hashes em auditorias **autorizadas**.

## Recursos
- Entrada manual de hash ou carregamento por arquivo.
- Identificação de tipo com `hashid`.
- Sugestão de modo hashcat por tamanho do hash:
  - 32 chars → MD5 (`-m 0`)
  - 40 chars → SHA1 (`-m 100`)
  - 64 chars → SHA256 (`-m 1400`)
- Seleção de wordlist padrão ou personalizada.
- Execução com `hashcat` (preferencial) ou `john` (fallback).
- Salvamento de resultados em `output/results.txt`.

## Estrutura
```
mecha-hasha/
├── mecha-hasha.sh
├── core/
│   ├── hash_detect.sh
│   ├── attack.sh
│   └── wordlist.sh
├── utils/
│   ├── colors.sh
│   └── validator.sh
├── wordlists/
│   └── rockyou.txt
├── output/
│   └── results.txt
└── README.md
```

## Uso
```bash
cd mecha-hasha
chmod +x mecha-hasha.sh core/*.sh utils/*.sh
./mecha-hasha.sh
```

## Aviso legal
Use somente em ambientes com autorização formal.
