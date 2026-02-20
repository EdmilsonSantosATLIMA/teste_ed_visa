--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Realizar a criação da view para o item 2 do Desafio.
--===============================================================================================================================================================

--===============================================================================================================================================================
-- Criação da View
--===============================================================================================================================================================
CREATE OR REPLACE VIEW dw.vw_associado_flat AS
WITH referencia AS (
    SELECT MAX(dt.data_completa) AS data_ref
    FROM dw.fato_transacoes ft
    JOIN dw.dim_tempo dt 
        ON ft.sk_tempo = dt.sk_tempo
),
ultimos_3_meses AS (
    SELECT
        ft.sk_associado,
        dt.data_completa,
        dm.nom_modalidade as nome_modalidade
    FROM dw.fato_transacoes ft
    JOIN dw.dim_tempo dt 
        ON ft.sk_tempo = dt.sk_tempo
    JOIN dw.dim_modalidade dm 
        ON ft.sk_modalidade = dm.sk_modalidade
    WHERE dt.data_completa >= (
        SELECT date_trunc('month', data_ref) - INTERVAL '2 months'
        FROM referencia
    )
),

agregacao AS (
    SELECT
        sk_associado,
        COUNT(DISTINCT date_trunc('month', data_completa)) AS meses_distintos,
        MAX(CASE WHEN nome_modalidade LIKE 'CR%DITO' THEN 1 ELSE 0 END) AS flag_credito,
        MAX(CASE WHEN nome_modalidade LIKE 'D%BITO' THEN 1 ELSE 0 END) AS flag_debito
    FROM ultimos_3_meses
    GROUP BY sk_associado
)
SELECT
    sk_associado,
    CASE WHEN meses_distintos = 3 THEN TRUE ELSE FALSE END AS associado_frequente,
    CASE WHEN flag_credito = 1 THEN TRUE ELSE FALSE END AS associado_ativo_credito,
    CASE WHEN flag_debito = 1 THEN TRUE ELSE FALSE END AS associado_ativo_debito
FROM agregacao;



