# Changelog

## 1.3 — 2026-05-16

- Menu de contexto (botão direito) com "Recarregar cota" e "Recarregar status" separados
- Script aceita argumento `usage` ou `status` para buscar só o que é necessário
- Timeout adicionado ao curl do status (3s connect, 5s total) para evitar travamento no reload manual
- Clique esquerdo mantido como reload completo (cota + status)

## 1.2 — 2026-05-15

- Bolinha colorida de status do Claude (verde/amarelo/laranja/vermelho) após os percentuais
- Consulta `status.claude.com/api/v2/status.json` a cada 5 minutos junto com o uso
- Formato exibido: `Claude  5h: XX%  |  7d: XX% | ●`

## 1.1 — 2026-05-14

- Ícone do Claude na barra (favicon extraído de claude.ai)
- Clique no widget atualiza os dados imediatamente
- Plasmoid movido para `claude_usage/plasmoid/` com symlink em `~/.local/share/plasma/plasmoids/`

## 1.0 — 2026-05-14

- Consulta autenticada via token OAuth do Claude Code
- Exibe utilização nas janelas de 5h e 7d
- Widget KDE Plasma 6 minimalista sem dependências externas
