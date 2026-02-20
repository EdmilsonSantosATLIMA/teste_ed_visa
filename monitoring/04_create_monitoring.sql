--===============================================================================================================================================================
--Card:teste VISA/Sicredi
--Autor:Edmilson Lima
--Data: 20/02/2026
--Objetivo: Criar a estrutura de monitoramento da pipeline do projeto, para realização do teste para a vaga de engenheiro de dados da VISA/Sicredi.
--===============================================================================================================================================================

--===============================================================================================================================================================
--Criação do SCHEMA
--===============================================================================================================================================================
CREATE SCHEMA IF NOT EXISTS monitoring;

--===============================================================================================================================================================
--Criação da tabela 
--===============================================================================================================================================================
CREATE TABLE IF NOT EXISTS monitoring.pipeline_log (
    id SERIAL PRIMARY KEY,
    etapa TEXT,
    registros_processados INT,
    data_execucao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE monitoring.pipeline_log IS 'Tabela que contém os dados de processamento.';
COMMENT ON COLUMN monitoring.pipeline_log.id IS 'Chave primaria';
COMMENT ON COLUMN monitoring.pipeline_log.etapa IS 'Nome da etapa que estamos executando';
COMMENT ON COLUMN monitoring.pipeline_log.registros_processados IS 'Quantidade de registros inseridos na fato';
COMMENT ON COLUMN monitoring.pipeline_log.data_execucao IS 'Data e hora de carga do registro.';

