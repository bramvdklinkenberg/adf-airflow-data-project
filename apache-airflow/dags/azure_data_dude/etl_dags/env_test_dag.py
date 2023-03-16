from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.bash import BashOperator
with DAG(
    "test_dag",
    default_args={
        "depends_on_past": False,
        "email_on_failure": False,
        "email_on_retry": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    description="A test dag",
    schedule=timedelta(hours=1),
    start_date=datetime(2023, 3, 16),
    catchup=False,
    tags=["test"],
) as dag:

    print_env = BashOperator(
        task_id="print_date",
        bash_command="env",
    )

    print_env
