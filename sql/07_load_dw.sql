--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Executar a carga dos dados da camada trusted para a camada dw.
--===============================================================================================================================================================

--===============================================================================================================================================================
--Dimensão: dim_associado
--===============================================================================================================================================================
MERGE INTO dw.dim_associado d
USING (
    SELECT *
    FROM trusted.associado
) s
ON (d.num_cpf_cnpj = s.num_cpf_cnpj)
WHEN MATCHED THEN
    UPDATE SET
        des_nome_associado = s.des_nome_associado,
        dat_associacao = s.dat_associacao,
        cod_faixa_renda = s.cod_faixa_renda,
        des_faixa_renda = s.des_faixa_renda,
        dat_carga = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        num_cpf_cnpj,
        des_nome_associado,
        dat_associacao,
        cod_faixa_renda,
        des_faixa_renda,
        dat_carga
    )
    VALUES (
        s.num_cpf_cnpj,
        s.des_nome_associado,
        s.dat_associacao,
        s.cod_faixa_renda,
        s.des_faixa_renda,
        CURRENT_TIMESTAMP
    );

--===============================================================================================================================================================
--Dimensão: dim_modalidade
--===============================================================================================================================================================
MERGE INTO dw.dim_modalidade d
USING (
    SELECT DISTINCT
        nom_modalidade
    FROM trusted.transacoes
) s
ON (d.nom_modalidade = s.nom_modalidade)
WHEN NOT MATCHED THEN
    INSERT (
        nom_modalidade,
        dat_carga
    )
    VALUES (
        s.nom_modalidade,
        CURRENT_TIMESTAMP
    );

--===============================================================================================================================================================
--Dimensão: dim_agencia
--===============================================================================================================================================================
MERGE INTO dw.dim_agencia d
USING (
    SELECT
        cod_cooperativa,
        cod_agencia,
        des_nome_cooperativa,
        des_nome_agencia
    FROM trusted.agencia
) s
ON (
    d.cod_cooperativa = s.cod_cooperativa
    AND d.cod_agencia = s.cod_agencia
)
WHEN MATCHED THEN
    UPDATE SET
        des_nome_cooperativa = s.des_nome_cooperativa,
        des_nome_agencia = s.des_nome_agencia,
        dat_carga = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        cod_cooperativa,
        cod_agencia,
        des_nome_cooperativa,
        des_nome_agencia,
        dat_carga
    )
    VALUES (
        s.cod_cooperativa,
        s.cod_agencia,
        s.des_nome_cooperativa,
        s.des_nome_agencia,
        CURRENT_TIMESTAMP
    );

--===============================================================================================================================================================
--Fato: fato_transacoes
--===============================================================================================================================================================
INSERT INTO dw.fato_transacoes (
    sk_agencia,
    sk_associado,
    sk_tempo,
    sk_modalidade,
    cod_transacao,
    vlr_transacao,
    nom_cidade_estabelecimento,
    dat_carga
)
SELECT
    COALESCE(da.sk_agencia, -1),
    COALESCE(ds.sk_associado, -1),
    COALESCE(dt.sk_tempo, -1),
    COALESCE(dm.sk_modalidade, -1),
    t.cod_transacao,
    t.vlr_transacao,
    t.nom_cidade_estabelecimento,
    CURRENT_TIMESTAMP
FROM trusted.transacoes t
LEFT JOIN dw.dim_agencia da
    ON da.cod_cooperativa = t.cod_cooperativa
    AND da.cod_agencia = t.cod_agencia
LEFT JOIN dw.dim_associado ds
    ON ds.num_cpf_cnpj = t.num_cpf_cnpj
LEFT JOIN dw.dim_tempo dt
    ON dt.data_completa = DATE(t.dat_transacao)
LEFT JOIN dw.dim_modalidade dm
    ON dm.nom_modalidade = t.nom_modalidade
ON CONFLICT (cod_transacao) DO NOTHING;

--===============================================================================================================================================================
--Monitoriamento
--===============================================================================================================================================================
INSERT INTO monitoring.pipeline_log (
    etapa, 
    registros_processados
    )
SELECT
    'load_fato_transacoes',
    COUNT(*)
FROM dw.fato_transacoes
WHERE dat_carga >= CURRENT_DATE;