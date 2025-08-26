FROM python:3.9-slim

WORKDIR /mlflow

RUN pip install --no-cache-dir \
    mlflow==2.8.0 \
    psycopg2-binary==2.9.9 \
    boto3==1.29.7

EXPOSE 5000

CMD ["mlflow", "server", \
     "--backend-store-uri", "postgresql://fraud_gen_user:fraud_gen_pass@postgres:5432/mlflow", \
     "--default-artifact-root", "/mlflow/artifacts", \
     "--host", "0.0.0.0", \
     "--port", "5000"]
