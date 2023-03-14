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
def weather_data_dag():
    """
    ### Weather API Data ETL DAG
    This DAG Extracts Weather Data from a public API, Transforms the data and Loads it into a Azure Postgresql Database
    """
    @task()
    def extract_weather_data(api_url):
        from azure_data_dude.modules.weather_data import get_api_response

        json_response = get_api_response(api_url)
        return json_response

    @task()
    def transform_weather_data(json_response):
        from azure_data_dude.modules.weather_data import transform_weather_data

        df = transform_weather_data(json_response)
        return df

    @task()
    def connect_to_databases():
        from azure_data_dude.modules.utils import get_postgres_connection

        conn, cursor = get_postgres_connection()
        return conn, cursor

    @task()
    def load_data(df, conn, cursor, table_name):
        from azure_data_dude.modules.weather_data import load_weather_data

        load_weather_data(df, conn, cursor, table_name)
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

    weather_data = extract_weather_data("TODO")
    df = transform_weather_data(weather_data)
    conn, cursor = connect_to_databases()
    load_data(df, conn, cursor, "weather_data")
    view_data(cursor, "weather_data")
    disconnect_from_database(conn, cursor)


weather_etl_dag = weather_data_dag()
