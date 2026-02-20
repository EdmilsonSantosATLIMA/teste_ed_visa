--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Executar a carga dos dados da camada raw para a camada trusted.
--===============================================================================================================================================================

--===============================================================================================================================================================
--tabela agencia
--===============================================================================================================================================================
MERGE INTO trusted.agencia t
USING (
    SELECT DISTINCT
        LPAD(TRIM(CAST(cod_cooperativa AS TEXT)), 4, '0') AS cod_cooperativa,
        INITCAP(TRIM(des_nome_cooperativa)) AS des_nome_cooperativa,
        LPAD(TRIM(CAST(cod_agencia AS TEXT)), 4, '0') AS cod_agencia,
        INITCAP(TRIM(des_nome_agencia)) AS des_nome_agencia
    FROM raw.agencia
) s
ON (
    t.cod_cooperativa = s.cod_cooperativa
    AND t.cod_agencia = s.cod_agencia
)
WHEN MATCHED THEN
    UPDATE SET
        des_nome_cooperativa = s.des_nome_cooperativa,
        des_nome_agencia = s.des_nome_agencia,
        dat_carga = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        cod_cooperativa,
        des_nome_cooperativa,
        cod_agencia,
        des_nome_agencia,
        dat_carga
    )
    VALUES (
        s.cod_cooperativa,
        s.des_nome_cooperativa,
        s.cod_agencia,
        s.des_nome_agencia,
        CURRENT_TIMESTAMP
    );

--===============================================================================================================================================================
--tabela associado
--===============================================================================================================================================================
MERGE INTO trusted.associado t
USING (
    SELECT DISTINCT
        md5(TRIM(num_cpf_cnpj)) AS num_cpf_cnpj,
        INITCAP(TRIM(des_nome_associado)) AS des_nome_associado,
        TO_DATE(dat_associacao, 'DD/MM/YYYY') AS dat_associacao,
        cod_faixa_renda::INT AS cod_faixa_renda,
        INITCAP(TRIM(des_faixa_renda)) AS des_faixa_renda
    FROM raw.associado
) s
ON (t.num_cpf_cnpj = s.num_cpf_cnpj)
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
--tabela transacoes
--===============================================================================================================================================================
MERGE INTO trusted.transacoes t
USING (
    SELECT DISTINCT
        md5(
            concat_ws('|',
                TRIM(CAST(num_cpf_cnpj AS TEXT)),
                TRIM(CAST(cod_cooperativa AS TEXT)),
                TRIM(CAST(cod_agencia AS TEXT)),
                TRIM(CAST(cod_conta AS TEXT)),
                TRIM(CAST(num_plastico AS TEXT)),
                TRIM(dat_transacao),
                TRIM(vlr_transacao)
            )
        ) AS cod_transacao,

        md5(TRIM(CAST(num_cpf_cnpj AS TEXT))) AS num_cpf_cnpj,
        LPAD(TRIM(CAST(cod_cooperativa AS TEXT)), 4, '0') AS cod_cooperativa,
        LPAD(TRIM(CAST(cod_agencia AS TEXT)), 4, '0') AS cod_agencia,
        LPAD(TRIM(CAST(cod_conta AS TEXT)),5, '0') AS cod_conta,
        LPAD(TRIM(CAST(num_plastico AS TEXT)),5, '0')AS num_plastico,
        TO_TIMESTAMP(dat_transacao, 'DD/MM/YYYY HH24:MI:SS') AS dat_transacao,
        REPLACE(TRIM(vlr_transacao), ',', '.')::NUMERIC(18,2) AS vlr_transacao,
        UPPER(TRIM(nom_modalidade)) AS nom_modalidade,
        INITCAP(TRIM(nom_cidade_estabelecimento)) AS nom_cidade_estabelecimento
    FROM raw.transacoes
) s
ON (t.cod_transacao = s.cod_transacao)
WHEN MATCHED THEN
    UPDATE SET
        nom_modalidade = s.nom_modalidade,
        nom_cidade_estabelecimento = s.nom_cidade_estabelecimento,
        vlr_transacao = s.vlr_transacao,
        dat_carga = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        cod_transacao,
        num_cpf_cnpj,
        cod_cooperativa,
        cod_agencia,
        cod_conta,
        num_plastico,
        dat_transacao,
        vlr_transacao,
        nom_modalidade,
        nom_cidade_estabelecimento,
        dat_carga
    )
    VALUES (
        s.cod_transacao,
        s.num_cpf_cnpj,
        s.cod_cooperativa,
        s.cod_agencia,
        s.cod_conta,
        s.num_plastico,
        s.dat_transacao,
        s.vlr_transacao,
        s.nom_modalidade,
        s.nom_cidade_estabelecimento,
        CURRENT_TIMESTAMP
    );