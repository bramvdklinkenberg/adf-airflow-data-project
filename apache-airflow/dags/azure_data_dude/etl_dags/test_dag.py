from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2023, 3, 15),
    'depends_on_past': False,
    'retries': 2
}

dag = DAG(
    'print_env_vars',
    default_args=default_args,
    schedule_interval='@hourly',
)


def print_env_vars():
    import os
    print(os.environ)


print_env_vars_task = PythonOperator(
    task_id='print_env_vars_task',
    python_callable=print_env_vars,
    dag=dag
)

print_env_vars_task
