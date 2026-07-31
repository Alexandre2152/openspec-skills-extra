---
name: openspec-detalhamento
description: Cria uma Solução Técnica detalhada para um card do Jira, incluindo tabela de tarefas e estimativa de esforço em horas. Use quando o usuário quiser gerar a solução passando apenas a URL/ID do card.
license: MIT
compatibility: Requer MCP jira-bradesco.
metadata:
  author: Alexandre Santana
  version: "1.0"
---

# Skill: Detalhamento de Solução Técnica

O objetivo desta skill é automatizar a criação da **Solução Técnica** de um card do Jira, garantindo padronização e incluindo uma tabela de tarefas com estimativa de esforço. Essa funcionalidade imita as características da solução do card SHOLLEXW07-6861.

## 1. Entrada
O usuário deve fornecer a URL ou o ID do card Jira ao acionar o comando `/opsx:detalhamento` (ou similar).

## 2. Ação: Busca no Jira e Tratamento de Anexos
Acione a ferramenta `jira_get_issue` do servidor `jira-bradesco` para obter os detalhes do card informado na entrada.
- Leia atentamente os campos `summary`, `description` e `comments` (incluindo notas da BIA Tech). Dê **muita atenção** às seções de: **Visão do Usuário**, **Visão Geral**, **Cenários de Aceitação** e **Regras de Negócio**.
- **Anexos (DOCs):** Verifique se o card possui anexos. Se houver, crie a pasta `DOCs` na raiz do repositório (se não existir) e utilize a ferramenta `jira_download_attachments` (ou equivalente) para baixar esses arquivos. Após o download, analise o conteúdo desses anexos para obter contexto e exemplos que ajudem na construção da Solução Técnica.

## 3. Ação: Geração do Artefato
Gere um artefato chamado `solucao_tecnica.md` (ou `implementation_plan.md`) para documentar e apresentar a solução técnica. 

### Estrutura Obrigatória do Artefato:

```markdown
# Solução Técnica: [Chave do Card] - [Título do Card]

## Contexto e Objetivo
Descreva o problema que está sendo resolvido e os objetivos principais da demanda com base nos dados do Jira. Apresente **apenas as informações da tarefa** de forma direta e objetiva. **Não inclua** notas de análise (ex: "Nota da Análise") ou meta-comentários informando onde ou como você encontrou a informação.

## Open Questions (Dúvidas em Aberto)
Documente pontos que requerem revisão do usuário ou decisões de design significativas.

## Proposed Changes (Alterações Propostas)
Divida as alterações por componente (ex: Backend Java, Frontend Angular).
Para cada componente, liste os arquivos que serão impactados utilizando o formato:
### [Nome do Componente]
#### [MODIFY] [Nome do Arquivo](caminho/para/arquivo)
- O que será alterado no arquivo.
#### [NEW] [Nome do Arquivo](caminho/para/arquivo)
- O que será criado.

## Regras Técnicas
<div style="color:red">

* Todas as camadas deverão possuir ZERO apontamentos no Fortify.
* Todas as camadas deverão estar com o relatório do Sonar apto para promoção em deploy.
* As camadas BFF e SRV devem possuir 100% de cobertura de testes unitários.
* Validações realizadas no frontend também devem ser obrigatoriamente realizadas no backend.
* Nenhum campo poderá ultrapassar os limites definidos no modelo de dados, tanto no frontend quanto no backend.
* Todas as camadas devem tratar adequadamente as mensagens de erro, evitando exposição de mensagens não amigáveis ao usuário.
* Todos os campos obrigatórios devem ser tratados conforme as regras de negócio.

</div>

## Dependências Técnicas
<div style="color:red">

*(Exiba a seção Dependências Técnicas APENAS se alguma dependência real for identificada na análise. Caso contrário, não a gere. Se gerar, liste as dependências).*

</div>

## Tabela de Tarefas e Esforço (Estimativa)
| Tarefa | Componente | Descrição da Atividade Técnica | Esforço Sugerido (Horas) |
|---|---|---|---|
| 1. Configuração/Análise | N/A | Análise de impacto e configuração | Xh |
| 2. Backend - [Nome] | SRV | Implementação no backend | Yh |
| 3. Frontend - [Nome] | FED | Implementação no frontend | Zh |
| **Total** | | | **Wh** |

*(Se alguma tarefa tiver menos de 4h, insira aqui como rodapé uma breve justificativa técnica, ex: *A tarefa 3 consiste apenas em ajuste visual simples*).*
*(Importante: Não adicione nenhum texto explicando que o esforço foi baseado em desenvolvedor pleno ou mencionando a regra de 4 horas. Apenas exiba a tabela de forma limpa).*

## Verification Plan (Plano de Validação)
Crie um **fluxo de teste passo a passo** que o desenvolvedor deverá executar. O fluxo deve guiá-lo navegando pelas telas do sistema para validar de ponta a ponta as alterações desenvolvidas.
```

## 4. Guardrails
- **Regras de Cor:** Apenas os itens (listas/textos) das seções "Regras Técnicas" e "Dependências Técnicas" devem ser formatados em vermelho. Nenhum outro item, cabeçalho ou seção da Solução Técnica pode receber a cor vermelha.
- **Idioma Obrigatório:** O artefato gerado deve ser redigido exclusivamente em **pt-BR (Português do Brasil)**.
- **Não implemente código:** Esta skill foca apenas na elaboração do planejamento e documentação (Solução Técnica).
- **Esforço para Desenvolvedor Pleno:** O cálculo de horas (Estimativa) deve considerar que as tarefas serão executadas por um desenvolvedor **Pleno**. Portanto, os tempos estimados devem ser aumentados em 15% em relação ao que seria cobrado de um Sênior.
- **Regra de Tempo Mínimo (4h):** Evite cadastrar tarefas com menos de 4 horas de esforço. Caso a tarefa realmente demande um tempo inferior a isso, você **deve** adicionar uma justificativa técnica como nota de rodapé abaixo da tabela. **É terminantemente proibido** mencionar no texto a existência da regra de limite mínimo de 4 horas, assim como é proibido incluir explicações no artefato final sobre como o cálculo foi realizado (ex: "As horas foram baseadas em dev Pleno").
- **Tabela Obrigatória:** Sempre inclua a Tabela de Tarefas e Esforço (contendo as 4 colunas padrão: Tarefa, Componente, Descrição e Esforço). É o requisito principal deste detalhamento.
