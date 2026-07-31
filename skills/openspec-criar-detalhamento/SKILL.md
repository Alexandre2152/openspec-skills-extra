---
name: openspec-criar-detalhamento
description: Publicar a Solução Técnica no Jira e transicionar a sub-tarefa de detalhamento para Iniciar. Use para automatizar as atualizações no Jira após gerar o detalhamento.
license: MIT
compatibility: Requer MCP jira-bradesco.
metadata:
  author: Alexandre Santana
  version: "1.0"
---

# Skill: Publicação de Solução Técnica no Jira

O objetivo desta skill é exportar o trabalho de detalhamento (Solução Técnica) já realizado localmente (via comando `/opsx:detalhamento`) de volta para o Jira. Ela elimina o trabalho manual de copiar/colar o detalhamento e gerencia a transição de status da sub-tarefa relacionada ao detalhamento.

## 1. Entrada
O usuário fornecerá a URL ou o ID do card Jira ao acionar o comando `/opsx:criar_detalhamento`.

## 2. Ação: Ler Solução Técnica Local
Procure nos artefatos da sessão atual (geralmente `solucao_tecnica.md` ou `implementation_plan.md`) e carregue o seu conteúdo.
- **Importante:** Se a Solução Técnica ainda não foi gerada, avise o usuário que ele precisa rodar o `/opsx:detalhamento` primeiro.

## 3. Ação: Converter Formatação e Atualizar o Campo "Solução Técnica"
Antes de enviar o conteúdo para o Jira, **converta toda a sintaxe Markdown para Jira Markup** (ex: troque `##` por `h2.`, `**` por `*`, adeque tabelas com `||` para cabeçalho e `|` para dados, e garanta que os blocos em `<div style="color:red">` virem `{color:red}...{color}`). O objetivo é garantir que o texto fique intuitivo e esteticamente agradável no Jira.
- Caso não tenha certeza sobre a chave do campo customizado no Jira correspondente à "Solução Técnica", utilize a ferramenta `jira_search_fields` buscando por "Solução Técnica" ou "Solucao Tecnica" para pegar seu ID (ex: `customfield_12345`).
- Utilize a ferramenta `jira_update_issue` passando a chave do card e o conteúdo já convertido em Jira Markup.

## 4. Ação: Transicionar Sub-tarefa para "Iniciar"
O card principal deve possuir sub-tarefas, e uma delas trata da construção da Solução Técnica.
- **Busca da Sub-tarefa:** Utilize `jira_search` com a JQL: `parent = "<ChaveDoCard>"` para listar as tarefas filhas.
- **Identificação:** Inspecione o campo `summary` das sub-tarefas retornadas. Identifique a sub-tarefa cujo título remeta a "informações de detalhamento" (ou algo análogo, como "Detalhamento").
- **Descobrir Transição:** Chame `jira_get_transitions` passando a chave da sub-tarefa encontrada. Procure no resultado qual é o ID da transição equivalente a "Iniciar" (ou "Em Andamento").
- **Mover Status:** Chame `jira_transition_issue` com a chave da sub-tarefa e o ID da transição para efetuar a mudança de status.

## 5. Guardrails
- **Não gere uma nova solução técnica:** Esta skill não serve para pensar em como implementar a demanda. Ela atua apenas como uma pipe de exportação de um texto já existente.
- **Descoberta de IDs Dinâmica:** Nunca fixe ou dedulza IDs de transição ou de campos customizados do Jira; eles podem variar de board para board. Sempre chame as APIs de listagem/pesquisa antes de engatilhar atualizações ou transições.
- Notifique o usuário se não encontrar a sub-tarefa de detalhamento, mas garanta que o card principal foi atualizado.
