---
name: "OPSX: Criar Detalhamento"
description: "Publicar a Solução Técnica no Jira e iniciar a sub-tarefa de detalhamento."
allowed-tools: mcp__jira-bradesco__*
category: "Workflow"
tags: ["workflow", "jira", "custom"]
---

# Workflow: opsx-criar-detalhamento

**Propósito:** Automatizar a publicação do artefato de Solução Técnica (gerado previamente pelo `/opsx:detalhamento`) diretamente no card do Jira, e mover a sub-tarefa correspondente para o status de "Iniciar".

**Gatilho:** `/opsx:criar_detalhamento <url-ou-id-do-card-jira>`

---

**Passo a Passo:**

1. **Ler a Solução Técnica Local:**
   - O agente deve acessar o diretório de artefatos da conversa atual e ler o conteúdo do arquivo onde a solução foi criada (por exemplo, `solucao_tecnica.md` ou `implementation_plan.md`).

2. **Converter Formatação e Atualizar o Card Principal no Jira:**
   - Antes de enviar, você **deve converter** todo o conteúdo Markdown da Solução Técnica gerada localmente para a sintaxe **Jira Markup** (ex: `h2.` no lugar de `##`, `*texto*` no lugar de `**texto**`, `||cabeçalho||` e `|célula|` para tabelas, `{code}` ou `{quote}` para blocos de código/citações). O texto final deve estar bem formatado e intuitivo para o padrão nativo do Jira (semelhante ao card SHOLLEXW07-6861).
   - Utilize a ferramenta `jira_search_fields` (do MCP server `jira-bradesco`) para encontrar o identificador exato do campo customizado "Solução Técnica", caso não o conheça.
   - Acione a ferramenta `jira_update_issue` passando a chave do card (extraída do gatilho) e inclua o conteúdo formatado em Jira Markup no campo correto.

3. **Encontrar a Sub-tarefa de Detalhamento:**
   - Execute uma busca utilizando a ferramenta `jira_search` com uma JQL para buscar as sub-tarefas do card principal (ex: `parent = "<ChaveDoCard>"`).
   - Percorra a lista retornada e identifique o card cuja descrição/título (summary) seja sobre "informações de detalhamento" (ou variações como "detalhamento").

4. **Transicionar a Sub-tarefa para "Iniciar":**
   - Acione `jira_get_transitions` informando a chave da sub-tarefa encontrada para listar os fluxos e status disponíveis.
   - Identifique o ID correspondente à transição de "Iniciar" (ou "Em Andamento" / "In Progress").
   - Execute `jira_transition_issue` na sub-tarefa, passando a transição correta, para alterar o seu status.

**Regras de Execução:**
- Certifique-se de que a Solução Técnica local existe antes de iniciar as interações com a API do Jira.
- Nomes de campos customizados (customfields) e IDs de transições (transitions) variam de projeto para projeto no Jira. Descubra-os dinamicamente antes de executar chamadas de update/transition.
