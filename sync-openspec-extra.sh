#!/usr/bin/env bash
# Instala as skills e workflows extras (Alexandre2152/openspec-skills-extra)
# somente nos agentes que existem no projeto atual.
set -e

REPO="Alexandre2152/openspec-skills-extra"
TMP_WF=".tmp-openspec-skills-extra"

HAS_CLAUDE=false
HAS_ANTIGRAVITY=false
[ -d ".claude" ] && HAS_CLAUDE=true
[ -d ".agent" ] && HAS_ANTIGRAVITY=true

AGENTS=()
$HAS_CLAUDE && AGENTS+=("claude-code")
$HAS_ANTIGRAVITY && AGENTS+=("antigravity")

if [ ${#AGENTS[@]} -eq 0 ]; then
  echo "Nenhuma pasta .claude ou .agent encontrada neste diretorio."
  echo "Rode 'npx @fission-ai/openspec@latest init' primeiro."
  exit 1
fi

echo ">> Agentes detectados: ${AGENTS[*]}"

# 1) Skills (SKILL.md) via CLI oficial, copia fisica, sem prompt
npx skills add "$REPO" --agent "${AGENTS[@]}" --copy -y

# 2) Corrige o mismatch .agents (plural, gerado pela CLI) -> .agent (singular, usado pelo Antigravity local)
if $HAS_ANTIGRAVITY && [ -d ".agents/skills" ]; then
  echo ">> Corrigindo .agents/ -> .agent/ (skills)"
  mkdir -p .agent/skills
  cp -r .agents/skills/. .agent/skills/
  rm -rf .agents
fi

# 3) Workflows: a CLI 'skills' nao entende esse formato, entao busca-se
#    o conteudo direto do repo e copia manualmente por agente.
rm -rf "$TMP_WF"
git clone --depth 1 --quiet "https://github.com/${REPO}.git" "$TMP_WF"

if $HAS_ANTIGRAVITY && [ -d "$TMP_WF/skills/workflows" ]; then
  echo ">> Copiando workflows para .agent/workflows/"
  mkdir -p .agent/workflows
  cp "$TMP_WF"/skills/workflows/*.md .agent/workflows/
fi

if $HAS_CLAUDE && [ -d "$TMP_WF/skills/commands/opsx" ]; then
  echo ">> Copiando workflows para .claude/commands/opsx/"
  mkdir -p .claude/commands/opsx
  cp "$TMP_WF"/skills/commands/opsx/*.md .claude/commands/opsx/
fi

rm -rf "$TMP_WF"

echo ">> Concluido."
