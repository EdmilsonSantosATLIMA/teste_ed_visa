import os
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime

# String de conexão via variável de ambiente
string_conexao_db = "DB_LINK"

engine = create_engine(string_conexao_db)

# Caminho base do projeto
diretorio = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def load_csv_to_raw(relative_path, table_name):
    file_path = os.path.join(diretorio, relative_path)

    df = pd.read_csv(
        file_path,
        sep=";",          # Definido explicitamente
        encoding="ISO-8859-1" # Encoding adequado para o arquivo
    )

    # adicionando coluna de carga, considerando o timestamp no momento do load
    df["dat_carga"] = datetime.now()

    df.to_sql(
        table_name,
        engine,
        schema="raw",
        if_exists="replace",
        index=False
    )

    print(f"Tabela raw.{table_name} carregada com sucesso.")


if __name__ == "__main__":
    load_csv_to_raw("base/db_pessoa.associado.csv", "associado")
    load_csv_to_raw("base/db_entidade.agencia.csv", "agencia")
    load_csv_to_raw("base/db_cartoes.transacoes.csv", "transacoes")

