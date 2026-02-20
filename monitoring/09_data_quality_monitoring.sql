--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Realizar a checagem de volumetria dos dados .
--===============================================================================================================================================================

--===============================================================================================================================================================
-- 1. Volume por mês - MONITORAMENTO OPERACIONAL
--===============================================================================================================================================================
SELECT
    dt.ano,
    dt.mes,
    COUNT(*) AS total_transacoes,
    SUM(f.vlr_transacao) AS valor_total
FROM dw.fato_transacoes f
JOIN dw.dim_tempo dt ON dt.sk_tempo = f.sk_tempo
GROUP BY dt.ano, dt.mes
ORDER BY dt.ano, dt.mes;

--===============================================================================================================================================================
-- 2. Volume por modalidade - MONITORAMENTO OPERACIONAL
--===============================================================================================================================================================
SELECT
    dm.nom_modalidade,
    COUNT(*) AS total_transacoes,
    SUM(f.vlr_transacao) AS valor_total
FROM dw.fato_transacoes f
JOIN dw.dim_modalidade dm ON dm.sk_modalidade = f.sk_modalidade
GROUP BY dm.nom_modalidade
ORDER BY valor_total DESC;

--===============================================================================================================================================================
-- 3. Crescimento diário - MONITORAMENTO OPERACIONAL
--===============================================================================================================================================================
SELECT
    dt.data_completa,
    COUNT(*) AS total_transacoes
FROM dw.fato_transacoes f
JOIN dw.dim_tempo dt ON dt.sk_tempo = f.sk_tempo
GROUP BY dt.data_completa
ORDER BY dt.data_completa;