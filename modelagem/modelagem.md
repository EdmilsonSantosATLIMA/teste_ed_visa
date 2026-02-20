# Modelagem Dimensional

## Esquema

Modelo estrela composto por:

Dimensões:
- dim_agencia
- dim_associado
- dim_modalidade
- dim_tempo

Fato:
- fato_transacoes

## Estratégias adotadas
## SCD Tipo 1

Aplicado nas dimensões para manter simplicidade e atualização direta de atributos.

## Fato de Evento Imutável

A tabela fato representa eventos transacionais e não sofre atualização após inserção.

## Chave Técnica

A transação utiliza hash MD5 como chave técnica para garantir idempotência.

## Registro Desconhecido (SK = -1)

Implementado para garantir resiliência da carga.

## Cidade como Atributo Degenerado

Mantida na fato por ausência de necessidade de hierarquia geográfica no escopo atual.