--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Criar a estrutura de dados do projeto, para realização do teste para a vaga de engenheiro de dados da VISA/Sicredi.
--===============================================================================================================================================================

--===============================================================================================================================================================
--tabela dim_tempo
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS dw.dim_tempo (
    sk_tempo INT PRIMARY KEY,
    data_completa DATE UNIQUE,
    ano INT,
    mes INT,
    nome_mes TEXT,
    trimestre INT,
    dia INT,
    dia_semana INT,
    nome_dia_semana TEXT,
    fim_de_semana BOOLEAN,
    dat_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE dw.dim_tempo IS 'Dimensão com os dados de Tempo';
COMMENT ON COLUMN dw.dim_tempo.sk_tempo IS 'Surrogate key da dimensão tempo (SCD Tipo 1).';
COMMENT ON COLUMN dw.dim_tempo.data_completa IS 'Data completa';
COMMENT ON COLUMN dw.dim_tempo.ano IS 'Informa o Ano da data';
COMMENT ON COLUMN dw.dim_tempo.mes IS 'Informa o mês da data';
COMMENT ON COLUMN dw.dim_tempo.nome_mes IS 'Informa o nome do mês da data';
COMMENT ON COLUMN dw.dim_tempo.trimestre IS 'Informa o trimestre da data';
COMMENT ON COLUMN dw.dim_tempo.dia IS 'Informa o dia da data';
COMMENT ON COLUMN dw.dim_tempo.dia_semana IS 'Informa o dia da semana da data';
COMMENT ON COLUMN dw.dim_tempo.nome_dia_semana IS 'Informa o nome do dia da semana da data';
COMMENT ON COLUMN dw.dim_tempo.fim_de_semana IS 'Informa se a data é Final de semana.';
COMMENT ON COLUMN dw.dim_tempo.dat_carga IS 'Data e hora de carga do registro.';

INSERT INTO dw.dim_tempo (
    sk_tempo,
    data_completa,
    ano,
    mes,
    dia,
    trimestre,
    nome_mes
)
VALUES (
    -1,
    '1900-01-01',
    1900,
    1,
    1,
    1,
    'DESCONHECIDO'
)
ON CONFLICT DO NOTHING;

INSERT INTO dw.dim_tempo
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS sk_tempo,
    d AS data_completa,
    EXTRACT(YEAR FROM d)::INT AS ano,
    EXTRACT(MONTH FROM d)::INT AS mes,
    TO_CHAR(d, 'TMMonth') AS nome_mes,
    EXTRACT(QUARTER FROM d)::INT AS trimestre,
    EXTRACT(DAY FROM d)::INT AS dia,
    EXTRACT(DOW FROM d)::INT AS dia_semana,
    TO_CHAR(d, 'TMDay') AS nome_dia_semana,
    CASE 
        WHEN EXTRACT(DOW FROM d) IN (0,6) THEN TRUE
        ELSE FALSE
    END AS fim_de_semana
FROM generate_series(
        '2015-01-01'::DATE,
        '2030-12-31'::DATE,
        '1 day'
     ) d;

--===============================================================================================================================================================
--tabela dim_associado
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS dw.dim_associado (
    sk_associado BIGSERIAL PRIMARY KEY,
    num_cpf_cnpj TEXT UNIQUE,
    des_nome_associado TEXT,
    cod_faixa_renda INT,
    des_faixa_renda TEXT,
    dat_associacao DATE,
    dat_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE dw.dim_associado IS 'Dimensão com os dados do associado';
COMMENT ON COLUMN dw.dim_associado.sk_associado IS 'Surrogate key da dimensão associado (SCD Tipo 1).';
COMMENT ON COLUMN dw.dim_associado.num_cpf_cnpj IS 'Numero do documento com hash do associado';
COMMENT ON COLUMN dw.dim_associado.des_nome_associado IS 'Nome do associado';
COMMENT ON COLUMN dw.dim_associado.cod_faixa_renda IS 'Código da faixa de renda do associado';
COMMENT ON COLUMN dw.dim_associado.des_faixa_renda IS 'Descrição da faixa de renda do associado';
COMMENT ON COLUMN dw.dim_associado.dat_associacao IS 'Data de cadastro do associado';
COMMENT ON COLUMN dw.dim_associado.dat_carga IS 'Data e hora de carga do registro.';

INSERT INTO dw.dim_associado (
    sk_associado,
    num_cpf_cnpj,
    des_nome_associado,
    dat_associacao,
    cod_faixa_renda,
    des_faixa_renda
)
VALUES (
    -1,
    'DESCONHECIDO',
    'DESCONHECIDO',
    NULL,
    NULL,
    'DESCONHECIDO'
)
ON CONFLICT DO NOTHING;

--===============================================================================================================================================================
--tabela dim_agencia
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS dw.dim_agencia (
    sk_agencia BIGSERIAL PRIMARY KEY,
    cod_cooperativa TEXT,
    cod_agencia TEXT,
    des_nome_cooperativa TEXT,
    des_nome_agencia TEXT,
    dat_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (cod_cooperativa, cod_agencia)
);
COMMENT ON TABLE dw.dim_agencia IS 'Dimensão com os dados de agência';
COMMENT ON COLUMN dw.dim_agencia.sk_agencia IS 'Surrogate key da dimensão agencia (SCD Tipo 1).';
COMMENT ON COLUMN dw.dim_agencia.cod_cooperativa IS 'Código da cooperativa';
COMMENT ON COLUMN dw.dim_agencia.cod_agencia IS 'Código da agência do associado';
COMMENT ON COLUMN dw.dim_agencia.des_nome_cooperativa IS 'Nome da cooperativa';
COMMENT ON COLUMN dw.dim_agencia.des_nome_agencia IS 'Codigo da agencia';
COMMENT ON COLUMN dw.dim_agencia.dat_carga IS 'Data e hora de carga do registro.';

INSERT INTO dw.dim_agencia (
    sk_agencia,
    cod_cooperativa,
    cod_agencia,
    des_nome_cooperativa,
    des_nome_agencia
)
VALUES (
    -1,
    '0000',
    '0000',
    'DESCONHECIDO',
    'DESCONHECIDO'
)
ON CONFLICT DO NOTHING;

--===============================================================================================================================================================
--tabela dim_modalidade
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS dw.dim_modalidade (
    sk_modalidade BIGSERIAL PRIMARY KEY,
    nom_modalidade TEXT UNIQUE,
    dat_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE dw.dim_modalidade IS 'Dimensão com os dados de Modalidade da transação';
COMMENT ON COLUMN dw.dim_modalidade.sk_modalidade IS 'Surrogate key da dimensão modalidade (SCD Tipo 1).';
COMMENT ON COLUMN dw.dim_modalidade.nom_modalidade IS 'Descrição da modalidade da transação';
COMMENT ON COLUMN dw.dim_modalidade.dat_carga IS 'Data e hora de carga do registro.';

INSERT INTO dw.dim_modalidade (
    sk_modalidade,
    nom_modalidade
)
VALUES (
    -1,
    'DESCONHECIDO'
)
ON CONFLICT DO NOTHING;

--===============================================================================================================================================================
--Criação da tabela na camada dw
--tabela fato_transacoes
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS dw.fato_transacoes (
    sk_fato_transacao SERIAL PRIMARY KEY,
    sk_agencia INT NOT NULL,
    sk_associado INT NOT NULL,
    sk_tempo INT NOT NULL,
    sk_modalidade INT NOT NULL,
    cod_transacao TEXT NOT NULL,
    vlr_transacao NUMERIC(18,2) NOT NULL,
    nom_cidade_estabelecimento TEXT,
    dat_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fato_agencia
        FOREIGN KEY (sk_agencia)
        REFERENCES dw.dim_agencia(sk_agencia),
    CONSTRAINT fk_fato_associado
        FOREIGN KEY (sk_associado)
        REFERENCES dw.dim_associado(sk_associado),
    CONSTRAINT fk_fato_tempo
        FOREIGN KEY (sk_tempo)
        REFERENCES dw.dim_tempo(sk_tempo),
    CONSTRAINT fk_fato_modalidade
        FOREIGN KEY (sk_modalidade)
        REFERENCES dw.dim_modalidade(sk_modalidade),
    CONSTRAINT uq_fato_transacao UNIQUE (cod_transacao)
);


COMMENT ON TABLE dw.fato_transacoes IS 'Fato com granularidade 1 linha = 1 transacao individual. Modelo dimensional estrela.';
COMMENT ON COLUMN dw.fato_transacoes.sk_fato_transacao IS 'Surrogate key da dimensão transacao (SCD Tipo 1).';
COMMENT ON COLUMN dw.fato_transacoes.sk_associado IS 'Surrogate key da dimensão associado (SCD Tipo 1).';
COMMENT ON COLUMN dw.fato_transacoes.sk_agencia IS 'Surrogate key da dimensão agencia (SCD Tipo 1).';
COMMENT ON COLUMN dw.fato_transacoes.sk_modalidade IS 'Surrogate key da dimensão modalidade (SCD Tipo 1).';
COMMENT ON COLUMN dw.fato_transacoes.sk_tempo IS 'Surrogate key da dimensão tempo (SCD Tipo 1).';
COMMENT ON COLUMN dw.fato_transacoes.vlr_transacao IS 'Valor monetário da transação do cartão\plástico do associado';
COMMENT ON COLUMN dw.fato_transacoes.cod_transacao IS 'Informa o codigo da transação criada para identificar a unicidade da transação realizada pelo o associado';
COMMENT ON COLUMN dw.fato_transacoes.nom_cidade_estabelecimento IS 'nome da cidade do Estabelecimento Valor monetário da transação do cartão\plástico do associado';
COMMENT ON COLUMN dw.fato_transacoes.dat_carga IS 'Data e hora de carga do registro.';

CREATE INDEX idx_fato_data ON dw.fato_transacoes(sk_tempo);
CREATE INDEX idx_fato_modalidade ON dw.fato_transacoes(sk_modalidade);
CREATE INDEX idx_fato_agencia ON dw.fato_transacoes(sk_agencia);

--===============================================================================================================================================================
--tabela fato_agregada
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS dw.fa_associado_ativo_3m (
    sk_associado INTEGER  PRIMARY KEY,
    associado_frequente BOOLEAN not null,
    associado_ativo_credito BOOLEAN not null,
    associado_ativo_debito BOOLEAN not null,
    dat_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);   
COMMENT ON TABLE dw.fa_associado_ativo_3m IS 'Fato com granularidade 1 linha = 1 associado. Modelo dimensional estrela.';
COMMENT ON COLUMN dw.fa_associado_ativo_3m.sk_associado IS 'Surrogate key da dimensão associado (SCD Tipo 1).';
COMMENT ON COLUMN dw.fa_associado_ativo_3m.associado_frequente IS 'Flag se o associado é ativo nos últimos 3 meses, usando o plástico\transação em qualquer modalidade';
COMMENT ON COLUMN dw.fa_associado_ativo_3m.associado_ativo_credito IS 'Flag se o associado é ativo nos últimos 3 meses, usando o plástico\transação na modalidade de crédito';
COMMENT ON COLUMN dw.fa_associado_ativo_3m.associado_ativo_debito IS 'Flag se o associado é ativo nos últimos 3 meses, usando o plástico\transação na modalidade de débito.';
COMMENT ON COLUMN dw.fa_associado_ativo_3m.dat_carga IS 'Data e hora de carga do registro.';

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