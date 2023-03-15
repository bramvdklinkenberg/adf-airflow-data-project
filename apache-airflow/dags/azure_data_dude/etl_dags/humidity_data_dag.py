import pendulum
from airflow.decorators import (
    dag,
    task
)


@dag(
    schedule_interval=None,
    start_date=pendulum.datetime(2021, 1, 1),
    catchup=False,
    tags=["etl", "humidity", "taskflow"]
)
def humidity_data_dag():
    """
    ### Humidity Data ETL DAG
    This DAG Extracts, Transforms and Loads Humidity Data from an Azure Blob Storage to Azure Postgresql Database
    """
    @task()
    def connect_to_storage():
        from azure_data_dude.modules.utils import get_blob_client

        storage_client = get_blob_client()
        return storage_client

    @task()
    def extract_storage_data(storage_client):
        from azure_data_dude.modules.csv_humidity_data import extract_csv_data

        csv_content = extract_csv_data(storage_client)
        return csv_content

    @task()
    def transform_storage_data(csv_content):
        from azure_data_dude.modules.csv_humidity_data import (
            convert_csv_to_dataframe,
            transform_humidity_data
        )

        df = convert_csv_to_dataframe(csv_content)
        df = transform_humidity_data(df)
        return df

    @task()
    def connect_to_databases():
        from azure_data_dude.modules.utils import get_postgres_connection

        conn, cursor = get_postgres_connection()
        return conn, cursor

    @task()
    def load_data(df, conn, cursor, table_name):
        from azure_data_dude.modules.csv_humidity_data import load_humidity_data

        load_humidity_data(df, conn, cursor, table_name)
        pass

    @task()
    def view_data(cursor, table_name):
        from azure_data_dude.modules.utils import view_table_name_data

        view_table_name_data(cursor, table_name)
        pass

    @task()
    def disconnect_from_database(conn, cursor):
        from azure_data_dude.modules.utils import close_postgres_connection

        close_postgres_connection(conn, cursor)
        pass

    storage_client = connect_to_storage()
    csv_content = extract_storage_data(storage_client)
    df = transform_storage_data(csv_content)
    conn, cursor = connect_to_databases()
    load_data(df, conn, cursor, "humidity")
    view_data(cursor, "humidity")
    disconnect_from_database(conn, cursor)


humidity_etl_dag = humidity_data_dag()
