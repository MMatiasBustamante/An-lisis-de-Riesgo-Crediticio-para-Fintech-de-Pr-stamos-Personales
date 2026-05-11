import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path
import os
from dotenv import load_dotenv

load_dotenv()


user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
name = os.getenv("DB_NAME")

connection_url = f"mysql+mysqlconnector://{user}:{password}@{host}:{port}/{name}"


DATA = Path("./data")
 
df = pd.read_csv(DATA/"credit_risk_dataset.csv")
 
print(f"Dataset cargado: {len(df):,} filas — {df.shape[1]} columnas")
print(f"Columnas: {list(df.columns)}\n")
 
try:
    engine = create_engine(connection_url)
 
    df.to_sql(
        name        = "loan_applications",
        con         = engine,
        if_exists   = "append",   
        index       = False,
    )
 
    print(f"Carga exitosa —  tabla loan_applications.")
 
except Exception as e:
    print(f"Error durante la carga: {e}")
    raise