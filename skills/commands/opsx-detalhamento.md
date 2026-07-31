---
name: "OPSX: Detalhamento"
description: "Gerar a Solução Técnica para um card do Jira"
allowed-tools: mcp__jira-bradesco__*
category: "Workflow"
tags: ["workflow", "jira", "custom"]
---

# Workflow: opsx-detalhamento

**Propósito:** Automatizar a criação de uma Solução Técnica detalhada para um card específico do Jira, contendo análise técnica e estimativa de esforço.

**Gatilho:** `/opsx:detalhamento <url-ou-id-do-card-jira>`

---

**Passo a Passo:**

1. **Buscar o Card no Jira e Anexos:**
   - Utilize a ferramenta `jira_get_issue` (do MCP server `jira-bradesco`) para buscar as informações do card informado.
   - Analise com extrema atenção os campos principais: **Visão do Usuário**, **Visão Geral**, **Cenários de Aceitação** e **Regras de Negócio** que constem na descrição ou nos comentários.
   - Verifique se há **anexos** vinculados ao card. Se houver, crie uma pasta chamada `DOCs` na raiz do repositório (caso não exista) e baixe os anexos para ela usando a ferramenta correspondente (`jira_download_attachments`). Analise os anexos baixados, pois eles frequentemente fornecem um contexto melhor ou exemplos para a tarefa.

2. **Análise de Requisitos:**
   - Analise o que precisa ser alterado de acordo com a descrição, os comentários (como métricas da BIA Tech) e os documentos anexos analisados.
   - Identifique os componentes impactados (ex: Backend Java, Frontend Angular, Banco de Dados).

3. **Gerar a Solução Técnica:**
   Crie um artefato Markdown chamado `solucao_tecnica.md` (ou atualize o `implementation_plan.md`) contendo as seguintes seções obrigatórias (baseadas na estrutura do card SHOLLEXW07-6861):

   - **Contexto e Objetivo:** Breve descrição do problema e do que a mudança realiza.
   - **Open Questions (Dúvidas em Aberto):** Perguntas para clarificação (usando alertas do GitHub se necessário).
   - **Proposed Changes (Alterações Propostas):** Agrupe os arquivos por componente e ordene logicamente. Use marcações como `[MODIFY]`, `[NEW]`, `[DELETE]`.
   - **Regras Técnicas:** Inclua exatamente as 7 regras técnicas fixas (Fortify, Sonar, Testes, Validações, etc). **Apenas os itens listados** nesta seção devem ser formatados na cor vermelha (ex: usando tags div com style color red no markdown); nenhum outro item de outras seções da Solução Técnica pode ficar em vermelho.
   - **Dependências Técnicas:** Se houver dependências identificadas, liste-as aqui, formatando **apenas os itens desta seção** na cor vermelha. Se não houver, omita a seção completamente.
   - **Tabela de Tarefas e Esforço (Estimativa):** (CRÍTICO) Deve conter uma tabela com 4 colunas (Tarefa, Componente, Descrição da Atividade Técnica, Esforço Sugerido). A coluna 'Componente' deve indicar obrigatoriamente se a tarefa pertence a SRV, BFF ou FED (ou N/A). *Atenção às regras de esforço descritas abaixo.*
   - **Verification Plan (Plano de Validação):** Descreva um fluxo de teste passo a passo que o desenvolvedor executará navegando pela tela do sistema, cobrindo todas as etapas desenvolvidas.

**Regras de Execução:**
- Não peça permissão para buscar o card, faça a busca imediatamente ao acionar o comando.
- **Idioma:** A documentação gerada deve ser inteiramente em **pt-BR (Português do Brasil)**.
- **Tabela de Tarefas:** Cada tarefa deve ter uma estimativa mínima de 4 horas. Não crie uma coluna de justificativa. Se for estritamente necessário atribuir menos de 4 horas a uma tarefa, inclua a justificativa técnica como uma nota de rodapé abaixo da tabela. Não adicione nenhum texto explícito sobre as regras de cálculo na Solução Técnica (ex: "baseado em desenvolvedor pleno" ou "mínimo de 4h").
- **Perfil do Desenvolvedor:** Aumente o tempo de desenvolvimento geral das tarefas baseando-se no fato de que o desenvolvedor será um profissional de nível **Pleno** (15% a mais em relação a um Sênior).
- Siga estritamente o formato de Solução Técnica definido.