# Projeto de Engenharia de Dados – Pipeline ETL com Data Warehouse

## Objetivo

Este projeto tem como objetivo demonstrar a construção de um pipeline de dados completo, contemplando:

- Extração
- Transformação
- Carga (ETL)
- Modelagem Dimensional
- Controle de Qualidade
- Idempotência
- Resiliência
- Performance

O pipeline simula um cenário financeiro, processando dados transacionais desde a camada bruta (raw) até um Data Warehouse modelado em esquema estrela, pronto para consumo analítico.

O foco principal é demonstrar boas práticas de Engenharia de Dados aplicáveis em ambientes de produção.

# Arquitetura do Pipeline

O fluxo de dados segue a arquitetura em três camadas:

RAW → TRUSTED → DW

## 1. Camada RAW

Responsável por armazenar os dados exatamente como recebidos da origem.

A camada RAW foi criada dinamicamente durante o processo de ingestão via Python.
O script de ingestão utiliza pandas.to_sql() para criar automaticamente as tabelas no schema raw, respeitando a estrutura do arquivo de origem.

Características:
- Estrutura próxima ao sistema de origem
- Dados ainda não padronizados
- Possíveis inconsistências
- Tipagem flexível (muitos campos como texto)
- Simulação de ingestão automatizada
Objetivo: preservar a integridade da informação original.

## 2. Camada TRUSTED

Responsável pela padronização e saneamento dos dados.

Transformações aplicadas:
- Conversão de tipos
- Padronização de textos (UPPER / INITCAP)
- Tratamento de espaços
- Conversão de valores monetários
- Hash de dados sensíveis (CPF)
- Geração de chave técnica de transação via MD5
Objetivo: fornecer dados confiáveis, limpos e consistentes.

## 3. Camada DW (Data Warehouse)

Modelagem dimensional em esquema estrela.

Dimensões:
- dim_agencia
- dim_associado
- dim_tempo
- dim_modalidade

Fato:
- fato_transacoes

Fato Agregada:
- fa_associado_ativo_3m

Características:
- Uso de surrogate keys
- Integridade referencial (FK)
- Fato de evento imutável
- Campo dat_carga para auditoria
Objetivo: estruturar os dados para análise eficiente e escalável.

# Estratégia de Idempotência

O pipeline foi projetado para permitir reprocessamento seguro sem gerar duplicidade.

Estratégias adotadas:
- Geração de cod_transacao via hash MD5 com base nos campos da transação
- Constraint UNIQUE na fato
- Uso de INSERT ... ON CONFLICT DO NOTHING
- MERGE nas dimensões (SCD Tipo 1)

Isso garante que:
- A execução pode ser repetida
- Não há duplicação de registros
- O pipeline é determinístico

# Estratégia de Resiliência

Para evitar falhas por ausência de correspondência dimensional, foi adotado o padrão de registro *“Desconhecido”*.

Cada dimensão contém um registro com SK = -1.

Na carga da fato:

- Caso não haja correspondência dimensional
- O valor é direcionado para SK = -1 via COALESCE

Isso garante que:

- A carga não falhe
- O dado não seja perdido
- A qualidade possa ser monitorada posteriormente

# Granularidade

Fato transacional: 1 registro por transação.
Tabela agregada (associado_flat): 1 registro por associado considerando os últimos 3 meses móveis.

# Estratégia de Performance
## Índices

Foram criados índices estratégicos na tabela fato:
- Índice por tempo
- Índice por modalidade
- Índice por agência

Objetivo:
- Melhorar agregações
- Reduzir tempo de leitura
- Otimizar consultas analíticas

## Possível Particionamento

Em cenário produtivo, recomenda-se:
- Particionamento da fato por data (range por ano/mês)

Benefícios:
- Redução de custo de leitura
- Melhor desempenho
- Manutenção simplificada

## Controle de Volume

Inclui:
- Tabela de log de execução
- Contagem de registros processados
- Consulta de registros com SK = -1
Isso permite monitorar:
- Crescimento do dataset
- Anomalias
- Volume diário de carga

# Melhorias Futuras

Este projeto pode evoluir para um ambiente ainda mais robusto com:

## Particionamento por Data

Implementação de range partition na fato para grandes volumes.

## Orquestração com Airflow

Automação do pipeline com DAGs agendadas.

## Migração para Spark / Databricks

Execução distribuída das transformações para maior escalabilidade.

## Armazenamento em Data Lake

Uso de arquitetura Lakehouse com camadas bronze/silver/gold.

# Decisões Arquiteturais Relevantes

Fato modelada como evento imutável (sem MERGE).

*nom_cidade_estabelecimento* mantida como atributo degenerado na fato por não haver necessidade de hierarquia geográfica no escopo atual.

Uso de SCD Tipo 1 nas dimensões.

Separação clara entre data do evento e data de carga.

# Como Executar
- Criar banco PostgreSQL
- Configurar variáveis de conexão
- Executar ingestão:
- Executar scripts SQL na ordem:
    01 → 02 → 03 → 04
- python etl
    05_ingestao_csv_to_raw.py
-Executar scripts SQL na ordem:
    06 → 07 → 08 → 09

# Encerramento

Este projeto foi desenvolvido com foco em boas práticas de Engenharia de Dados, priorizando:
- Idempotência
- Resiliência
- Modelagem dimensional adequada
- Performance
- Escalabilidade
A estrutura foi pensada para simular um ambiente de produção real, mantendo clareza arquitetural e rastreabilidade do pipeline.
