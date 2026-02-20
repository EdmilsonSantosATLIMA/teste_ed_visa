--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Criar a estrutura de dados do projeto, para realização do teste para a vaga de engenheiro de dados da VISA/Sicredi.
--===============================================================================================================================================================

--===============================================================================================================================================================
--Criação das tabelas na camada trusted
--tabela agencia
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS trusted.agencia (
    cod_cooperativa TEXT,
    des_nome_cooperativa TEXT,
    cod_agencia TEXT,
    des_nome_agencia TEXT,
    dat_carga TIMESTAMP,
  CONSTRAINT pk_agencia 
  PRIMARY KEY (cod_cooperativa, cod_agencia)
);
--===============================================================================================================================================================
--Comentários da tabela agencia e suas colunas
--===============================================================================================================================================================
COMMENT ON TABLE trusted.agencia IS 'Tabela de agencias na camada trusted';
COMMENT ON COLUMN trusted.agencia.cod_cooperativa IS 'Codigo da cooperativa';
COMMENT ON COLUMN trusted.agencia.des_nome_cooperativa IS 'Nome da cooperativa';
COMMENT ON COLUMN trusted.agencia.cod_agencia IS 'Codigo da agencia';
COMMENT ON COLUMN trusted.agencia.des_nome_agencia IS 'Nome da agencia';
COMMENT ON COLUMN trusted.agencia.dat_carga IS 'Data e hora de carga do registro';

--===============================================================================================================================================================
--tabela associado
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS trusted.associado (
  num_cpf_cnpj TEXT,
  des_nome_associado TEXT,
  dat_associacao DATE,
  cod_faixa_renda INT,
  des_faixa_renda TEXT,
  dat_carga TIMESTAMP,
  CONSTRAINT pk_associado
  PRIMARY KEY (num_cpf_cnpj)
);
--===============================================================================================================================================================
--Comentários da tabela associado e suas colunas
--===============================================================================================================================================================
COMMENT ON TABLE trusted.associado IS 'Tabela de associado na camada trusted';
COMMENT ON COLUMN trusted.associado.num_cpf_cnpj IS 'Numero do documento com hash do associado';
COMMENT ON COLUMN trusted.associado.des_nome_associado IS 'Nome do associado';
COMMENT ON COLUMN trusted.associado.dat_associacao IS 'Data de cadastro do associado';
COMMENT ON COLUMN trusted.associado.cod_faixa_renda IS 'Código da faixa de renda do associado';
COMMENT ON COLUMN trusted.associado.des_faixa_renda IS 'Descrição da faixa de renda do associado';
COMMENT ON COLUMN trusted.associado.dat_carga IS 'Data e hora de carga do registro';

--===============================================================================================================================================================
--tabela transacoes
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS trusted.transacoes(
  cod_transacao TEXT,
  num_cpf_cnpj TEXT,
  cod_cooperativa TEXT,
  cod_agencia TEXT,
  cod_conta TEXT,
  num_plastico TEXT,
  dat_transacao TIMESTAMP,
  vlr_transacao NUMERIC(18,2),
  nom_modalidade TEXT,
  nom_cidade_estabelecimento TEXT,
  dat_carga TIMESTAMP,
  CONSTRAINT pk_transacoes 
  PRIMARY KEY (cod_transacao),
  
  CONSTRAINT fk_transacao_associado
  FOREIGN KEY (num_cpf_cnpj)
  REFERENCES trusted.associado (num_cpf_cnpj),
  
  CONSTRAINT fk_transacao_agencia
  FOREIGN KEY (cod_cooperativa, cod_agencia)
  REFERENCES trusted.agencia (cod_cooperativa, cod_agencia)
  
);
--===============================================================================================================================================================
--Comentários da tabela transacoes e suas colunas
--===============================================================================================================================================================
COMMENT ON TABLE trusted.transacoes IS 'Tabela de transacões na camada trusted';
COMMENT ON COLUMN trusted.transacoes.cod_transacao IS 'Código da transação, campo concatenado com outras colunas para criar a chave PK da transação';
COMMENT ON COLUMN trusted.transacoes.num_cpf_cnpj IS 'Número do documento com hash do associado';
COMMENT ON COLUMN trusted.transacoes.cod_cooperativa IS 'Código da cooperativa';
COMMENT ON COLUMN trusted.transacoes.cod_agencia IS 'Código da agência do associado';
COMMENT ON COLUMN trusted.transacoes.cod_conta IS 'Código da conta do associado';
COMMENT ON COLUMN trusted.transacoes.num_plastico IS 'Número do cartão\plástico do associado';
COMMENT ON COLUMN trusted.transacoes.dat_transacao IS 'Data e hora da transação do cartão\plástico do associado';
COMMENT ON COLUMN trusted.transacoes.vlr_transacao IS 'Valor monetário da transação do cartão\plástico do associado';
COMMENT ON COLUMN trusted.transacoes.nom_modalidade IS 'Descrição do tipo de transação. Ex: Débito ou Crédito';
COMMENT ON COLUMN trusted.transacoes.nom_cidade_estabelecimento IS 'Descrição do nome da cidade do estabelecimento, que ocorreu a tratransação do cartão\plástico do associado';
COMMENT ON COLUMN trusted.transacoes.dat_carga IS 'Data e hora de carga do registro';

