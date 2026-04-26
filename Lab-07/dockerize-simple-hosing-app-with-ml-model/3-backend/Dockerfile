FROM python:3.10-slim
WORKDIR /app
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ./app .
ENV MODEL_API_BASE_URL=http://192.168.65.91:8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
