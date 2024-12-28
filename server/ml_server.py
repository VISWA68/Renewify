from flask import Flask, request, jsonify
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from datetime import datetime
import pvlib

app = Flask(__name__)

df = pd.read_csv('data.csv')

X = df[["Average_Consumption", "Solar_Potential"]]
y = df["Next_Month_Solar_Output"]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = LinearRegression()
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print(f"Model Training Completed! Mean Squared Error: {mse:.2f}")

def get_solar_potential(lat, lon):
    current_date = datetime.now()
    next_month = (current_date.month % 12) + 1  

    times = pd.date_range(current_date, periods=1, freq='D', tz='UTC')  
    location = pvlib.location.Location(latitude=lat, longitude=lon)
    solar_position = location.get_solarposition(times)
    
    clearsky = location.get_clearsky(times)
    ghi = clearsky['ghi'].mean()
    dni = clearsky['dni'].mean()
    dhi = clearsky['dhi'].mean()

    solar_potential = ghi + 0.5 * dni - 0.2 * dhi  
    return solar_potential

def predict_next_month_solar(lat, lon, avg_consumption):
    solar_potential = get_solar_potential(lat, lon)

    input_data = np.array([[avg_consumption, solar_potential]])

    predicted_output = model.predict(input_data)
    return predicted_output[0]

@app.route('/predict_energy', methods=['POST'])
def predict_energy():
    try:
        data = request.json
        latitude = float(data.get('latitude'))
        longitude = float(data.get('longitude'))
        avg_consumption = float(data.get('electricity_consumption'))
        
        predicted_output = predict_next_month_solar(latitude, longitude, avg_consumption)
        print(predicted_output)
        
        return jsonify({
            "predicted_next_month_energy_output_kwh": round(predicted_output, 2)
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)