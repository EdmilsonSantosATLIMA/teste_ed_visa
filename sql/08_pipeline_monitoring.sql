--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Realizar a checagem dos dados inseridos.
--===============================================================================================================================================================

--===============================================================================================================================================================
-- 1. Verificar duplicidade de transação
--===============================================================================================================================================================
SELECT cod_transacao, COUNT(*)
FROM dw.fato_transacoes
GROUP BY cod_transacao
HAVING COUNT(*) > 1;

--===============================================================================================================================================================
-- 2. Verificar registros com SK = -1
--===============================================================================================================================================================
SELECT COUNT(*) AS registros_com_sk_desconhecido
FROM dw.fato_transacoes
WHERE sk_agencia = -1
   OR sk_associado = -1
   OR sk_tempo = -1
   OR sk_modalidade = -1;

--===============================================================================================================================================================
-- 3. Volume total de registros na fato
--===============================================================================================================================================================
SELECT COUNT(*) AS total_registros
FROM dw.fato_transacoes;

--===============================================================================================================================================================
-- 4. Validação de integridade dimensional
--===============================================================================================================================================================
SELECT
    SUM(CASE WHEN da.sk_agencia IS NULL THEN 1 ELSE 0 END) AS sem_agencia,
    SUM(CASE WHEN ds.sk_associado IS NULL THEN 1 ELSE 0 END) AS sem_associado,
    SUM(CASE WHEN dt.sk_tempo IS NULL THEN 1 ELSE 0 END) AS sem_tempo,
    SUM(CASE WHEN dm.sk_modalidade IS NULL THEN 1 ELSE 0 END) AS sem_modalidade
FROM trusted.transacoes t
LEFT JOIN dw.dim_agencia da
    ON da.cod_cooperativa = t.cod_cooperativa
    AND da.cod_agencia = t.cod_agencia
LEFT JOIN dw.dim_associado ds
    ON ds.num_cpf_cnpj = t.num_cpf_cnpj
LEFT JOIN dw.dim_tempo dt
    ON dt.data_completa = DATE(t.dat_transacao)
LEFT JOIN dw.dim_modalidade dm
    ON dm.nom_modalidade = t.nom_modalidade;