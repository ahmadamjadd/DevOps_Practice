FROM python:3.10-slim
WORKDIR /app
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ./app .
COPY ./model/ /app/model/
ENV MODEL_FILENAME=house_price_prediction_model.joblib
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]


