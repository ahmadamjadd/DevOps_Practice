from fastapi import FastAPI, Request
import joblib
import numpy as np
import os

# Load trained model
MODEL_FILENAME = os.getenv("MODEL_FILENAME", "house_price_model.joblib")
model = joblib.load("model/" + MODEL_FILENAME)

app = FastAPI(title="House Price Prediction API - JSON", version="1.0")

@app.get("/")
def read_root():
    return {"message": "Welcome to the House Price Prediction API (JSON)"}

@app.post(
  "/predict",
      responses={
        200: {
            "description": "Unified Success/Failure JSON response",
            "content": {
                "application/json": {
                    "examples": {
                        "success": {
                            "summary": "Successful Prediction",
                            "value": {
                                "success": True,
                                "data": {
                                    "input_received": {
                                        "MedInc": 0.4,
                                        "HouseAge": 20,
                                        "AveRooms": 5,
                                        "AveBedrms": 1,
                                        "Population": 1000,
                                        "AveOccup": 3,
                                        "Latitude": 37,
                                        "Longitude": -120
                                    },
                                    "predicted_price": 1.5
                                },
                                "message": "Prediction successful"
                            }
                        },
                        "error": {
                            "summary": "Error Response",
                            "value": {
                                "success": False,
                                "error": {
                                    "code": 422,
                                    "message": "Missing required field: MedInc"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
)
async def predict_price(request: Request):
    """
    Accepts raw JSON in the POST body.
    
    Expected JSON keys (case-sensitive):
      - MedInc
      - HouseAge
      - AveRooms
      - AveBedrms
      - Population
      - AveOccup
      - Latitude
      - Longitude

    Example:
    {
      "MedInc": 3.2,
      "HouseAge": 20,
      "AveRooms": 5.5,
      "AveBedrms": 1.1,
      "Population": 1500,
      "AveOccup": 2.9,
      "Latitude": 34.05,
      "Longitude": -118.24
    }
    """
    try:
    	data = await request.json()

    	# Extract parameters (use defaults if missing)
    	MedInc = float(data.get("MedInc", 3.0))
    	HouseAge = float(data.get("HouseAge", 30.0))
    	AveRooms = float(data.get("AveRooms", 5.0))
    	AveBedrms = float(data.get("AveBedrms", 1.0))
    	Population = float(data.get("Population", 1000.0))
    	AveOccup = float(data.get("AveOccup", 3.0))
    	Latitude = float(data.get("Latitude", 37.0))
    	Longitude = float(data.get("Longitude", -122.0))

    	# Prepare input in the exact order used during training
    	input_data = np.array([[
          MedInc,
          HouseAge,
          AveRooms,
          AveBedrms,
          Population,
          AveOccup,
          Latitude,
          Longitude
    	]])

    	# Run prediction
    	prediction = model.predict(input_data)
    	prediction_raw = float(prediction[0])
    	prediction_dollars = float(prediction_raw * 100000)

    	return {
	  "success": True,
	  "data": {
            "input_received": data,
            "input_used": {
              "MedInc": MedInc,
              "HouseAge": HouseAge,
              "AveRooms": AveRooms,
              "AveBedrms": AveBedrms,
              "Population": Population,
              "AveOccup": AveOccup,
              "Latitude": Latitude,
              "Longitude": Longitude
            },
            "predicted_price": prediction_raw,
            "prediction_dollars": prediction_dollars
	  },
	  "message": "Prediciton successful"
    	}
    except Exception as e:
      return {
        "success": False,
        "error": {
          "code": 500,
          "message": str(e)
        }
      }
