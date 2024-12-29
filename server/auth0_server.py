from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from bson import ObjectId
from flask_cors import CORS
import logging
import os
from functools import wraps
import requests
import json
from jose import jwt
from dotenv import load_dotenv
import uuid
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from datetime import datetime
import pvlib

app = Flask(__name__)

app.config["MONGO_URI"] = os.getenv('URL')
mongo = PyMongo(app)
CORS(app)
load_dotenv()

users_collection = mongo.db.users
sellers_collection = mongo.db.sellers
shops_collection = mongo.db.shops
products_collection = mongo.db.products
service_providers_collection = mongo.db.service_providers
requests_collection = mongo.db.requests_collection

AUTH0_DOMAIN = os.load_dotenv('AUTH')
CLIENT_ID = os.load_dotenv('CLIENT')
CLIENT_SECRET = os.load_dotenv('SECRET')
API_IDENTIFIER = os.load_dotenv('API')


def get_auth0_token(email, password):
    """Get Auth0 token using email and password"""
    url = f"https://{AUTH0_DOMAIN}/oauth/token"
    payload = {
        'grant_type': 'password',
        'username': email,
        'password': password,
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'audience': API_IDENTIFIER,
        'scope': 'openid profile'
    }
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, json=payload, headers=headers)

    logging.debug(f"Auth0 response status code: {response.status_code}")
    logging.debug(f"Auth0 response body: {response.text}")

    if response.status_code == 200:
        return response.json()['access_token']
    else:
        logging.error(f"Error fetching Auth0 token: {response.status_code} - {response.text}")
        return None


@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json
        logging.debug(f"Incoming login request data: {data}")

        user = users_collection.find_one({"email": data["email"]})
        if not user or user["password"] != data["password"]: 
            return jsonify({"error": "Invalid credentials"}), 401

        seller = sellers_collection.find_one({"email": data["email"]})
        if not seller:
            return jsonify({"error": "Seller profile not found"}), 404

        auth0_token = get_auth0_token(data["email"], data["password"])
        if not auth0_token:
            return jsonify({"error": "Failed to get Auth0 token"}), 500

        shop = shops_collection.find_one({"seller_id": str(seller["_id"])})

        response = {
            "message": "Login successful",
            "seller_id": str(seller["_id"]),
            "auth0_token": auth0_token 
        }

        if shop:
            response["shop_id"] = str(shop["_id"])  

        return jsonify(response), 200

    except Exception as e:
        logging.error(f"Error in login route: {str(e)}") 
        return jsonify({"error": str(e)}), 500


def serialize_object_id(data):
    if isinstance(data, list):
        return [{**item, '_id': str(item['_id'])} for item in data]
    elif isinstance(data, dict):
        return {**data, '_id': str(data['_id'])}
    return data

def get_jwk():
    url = f"https://{AUTH0_DOMAIN}/.well-known/jwks.json"
    response = requests.get(url)
    return response.json()

def get_public_key(kid):
    jwks = get_jwk()
    for key in jwks["keys"]:
        if key["kid"] == kid:
            return jwt.algorithms.RSAAlgorithm.from_jwk(json.dumps(key))

# Verify the JWT token
def verify_token(token):
    try:
        unverified_header = jwt.get_unverified_header(token)
        if unverified_header is None:
            raise Exception("Authorization malformed.")
        
        rsa_key = {}
        if "kid" in unverified_header:
            rsa_key = get_public_key(unverified_header["kid"])
        
        payload = jwt.decode(
            token,
            rsa_key,
            algorithms=ALGORITHMS,
            audience=API_IDENTIFIER,
            issuer=f"https://{AUTH0_DOMAIN}/"
        )
        return payload
    except jwt.ExpiredSignatureError:
        raise Exception("token is expired")
    except jwt.JWTClaimsError:
        raise Exception("incorrect claims, please check the audience and issuer")
    except Exception:
        raise Exception("Unable to parse token")

def verify_jwt(token):
    try:
        jsonurl = urlopen(f"https://{AUTH0_DOMAIN}/.well-known/jwks.json")
        jwks = json.loads(jsonurl.read())
        unverified_header = jwt.get_unverified_header(token)

        rsa_key = {}
        for key in jwks['keys']:
            if key['kid'] == unverified_header['kid']:
                rsa_key = {
                    'kty': key['kty'],
                    'kid': key['kid'],
                    'use': key['use'],
                    'n': key['n'],
                    'e': key['e']
                }
        if not rsa_key:
            raise Exception("Unable to find appropriate key.")

        payload = jwt.decode(
            token,
            rsa_key,
            algorithms=ALGORITHMS,
            audience=API_AUDIENCE,
            issuer=f"https://{AUTH0_DOMAIN}/"
        )
        return payload
    except jwt.ExpiredSignatureError:
        raise Exception("Token has expired")
    except jwt.JWTClaimsError:
        raise Exception("Incorrect claims, please check the audience and issuer.")
    except Exception as e:
        raise Exception(f"Unable to parse authentication token: {str(e)}")


def requires_auth(f):
    def decorated(*args, **kwargs):
        auth_header = request.headers.get('Authorization', None)
        if not auth_header:
            return jsonify({"error": "Authorization header is missing"}), 401

        parts = auth_header.split()
        if parts[0].lower() != 'bearer':
            return jsonify({"error": "Authorization header must start with Bearer"}), 401
        elif len(parts) == 1:
            return jsonify({"error": "Token not found"}), 401
        elif len(parts) > 2:
            return jsonify({"error": "Authorization header must be Bearer token"}), 401

        token = parts[1]
        try:
            payload = verify_jwt(token)
            request.user = payload 
        except Exception as e:
            return jsonify({"error": str(e)}), 401

        return f(*args, **kwargs)
    decorated.__name__ = f.__name__
    return decorated

def serialize_object_id(data):
    if isinstance(data, list):
        return [{**item, '_id': str(item['_id'])} for item in data]
    elif isinstance(data, dict):
        return {**data, '_id': str(data['_id'])}
    return data

#logging.basicConfig(level=logging.DEBUG)


@app.route('/register', methods=['POST'])
def register_seller():
    try:
        data = request.json

        required_fields = ['name', 'email', 'password', 'phone']
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing {field}"}), 400

        if users_collection.find_one({"email": data["email"]}):
            return jsonify({"error": "Email already exists"}), 400

        user = {
            "name": data["name"],
            "email": data["email"],
            "password": data["password"],  
            "phone": data["phone"]
        }
        user_id = users_collection.insert_one(user).inserted_id

        seller = {
            "user_id": str(user_id),
            "name": data["name"],
            "email": data["email"],
            "phone": data["phone"],
            "shops": []
        }
        seller_id = sellers_collection.insert_one(seller).inserted_id

        return jsonify({"message": "Seller registered successfully", "seller_id": str(seller_id)}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/add_shop', methods=['POST'])
@requires_auth
def create_shop():
    try:
        data = request.json

        seller = sellers_collection.find_one({"_id": ObjectId(data["seller_id"])})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        shop_id = ObjectId()

        shop = {
            "_id": shop_id, 
            "seller_id": data["seller_id"],
            "shop_name": data["shop_name"],
            "address": data["address"],
            "upi_id": data["upi_id"],
            "shop_image": data.get("shop_image", ""), 
        }

        shops_collection.insert_one(shop)

        sellers_collection.update_one(
            {"_id": ObjectId(data["seller_id"])},
            {"$push": {"shops": str(shop_id)}}
        )

        return jsonify({
            "message": "Shop created successfully",
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/add_product', methods=['POST'])
@requires_auth
def add_product():
    try:
        data = request.json
        print(f"Incoming request: {data}")
        shop = shops_collection.find_one({"_id": ObjectId(data["shop_id"])})
        if not shop:
            return jsonify({"error": "Shop not found"}), 404

        seller = sellers_collection.find_one({"_id": ObjectId(data["seller_id"])})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        product = {
            "shop_id": data["shop_id"],
            "seller_id": data["seller_id"],
            "name": data["name"],
            "description": data["description"],
            "price": data["price"],
            "image": data.get("image", ""),
        }
        product_id = products_collection.insert_one(product).inserted_id

        return jsonify({"message": "Product added successfully", "product_id": str(product_id)}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/shops/<string:seller_id>', methods=['GET'])
@requires_auth
def get_shops_by_seller(seller_id):
    try:
        seller = sellers_collection.find_one({"_id": ObjectId(seller_id)})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        shops = list(shops_collection.find({"seller_id": seller_id}))
        for shop in shops:
            products = list(products_collection.find({"shop_id": str(shop["_id"])}))
            shop["products"] = serialize_object_id(products)

        return jsonify({"shops": serialize_object_id(shops)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/shops', methods=['GET'])
@requires_auth
def get_all_shops():
    try:
        shops = list(shops_collection.find({}))

        shops_data = []
        for shop in shops:
            shop_data = {
                "_id": str(shop["_id"]),
                "shop_name": shop.get("shop_name", ""),
                "address": shop.get("address", ""),
                "upi_id": shop.get("upi_id", ""),
                "seller_id": str(shop.get("seller_id", "")),
                "products": shop.get("products", []),
            }
            shops_data.append(shop_data)

        return jsonify({"message": "Shops retrieved successfully", "shops": shops_data}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/seller/<string:seller_id>', methods=['GET'])
@requires_auth
def get_seller_details(seller_id):
    try:
        seller = sellers_collection.find_one({"_id": ObjectId(seller_id)})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        shops = list(shops_collection.find({"seller_id": seller_id}))
        for shop in shops:
            products = list(products_collection.find({"shop_id": str(shop['_id'])}))
            shop['products'] = serialize_object_id(products)

        seller_data = {
            "seller_id": str(seller["_id"]),
            "name": seller["name"],
            "email": seller["email"],
            "phone": seller["phone"],
            "shops": serialize_object_id(shops),
        }

        return jsonify(seller_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

####################################Service Providers#################################################
@app.route('/register_service_provider', methods=['POST'])
def register_service_provider():
    try:
        data = request.json

        required_fields = ['name', 'email', 'password', 'phone', 'service_type']
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing {field}"}), 400

        if users_collection.find_one({"email": data["email"]}):
            return jsonify({"error": "Email already exists"}), 400

        user = {
            "name": data["name"],
            "email": data["email"],
            "password": data["password"],  
            "phone": data["phone"]
        }
        user_id = users_collection.insert_one(user).inserted_id

        service_provider = {
            "user_id": str(user_id),
            "name": data["name"],
            "email": data["email"],
            "phone": data["phone"],
            "service_type": data["service_type"],  
        }
        service_provider_id = service_providers_collection.insert_one(service_provider).inserted_id

        return jsonify({"message": "Service provider registered successfully", "service_provider_id": str(service_provider_id)}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/login_service_provider', methods=['POST'])
def login_service_provider():
    try:
        data = request.json

        user = users_collection.find_one({"email": data["email"]})
        if not user or user["password"] != data["password"]: 
            return jsonify({"error": "Invalid credentials"}), 401

        service_provider = service_providers_collection.find_one({"email": data["email"]})
        if not service_provider:
            return jsonify({"error": "Service provider profile not found"}), 404

        response = {
            "message": "Login successful",
            "service_provider_id": str(service_provider["_id"]),
            "service_type": service_provider["service_type"],  
        }

        return jsonify(response), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/get_service_provider/<string:service_provider_id>', methods=['GET'])
@requires_auth
def get_service_provider_details(service_provider_id):
    try:
        service_provider = service_providers_collection.find_one({"_id": ObjectId(service_provider_id)})
        if not service_provider:
            return jsonify({"error": "Service provider not found"}), 404

        service_provider_data = {
            "service_provider_id": str(service_provider["_id"]),
            "name": service_provider["name"],
            "email": service_provider["email"],
            "phone": service_provider["phone"],
            "service_type": service_provider["service_type"], 
        }

        return jsonify(service_provider_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/request_service', methods=['POST'])
@requires_auth
def request_service():
    try:
        data = request.json

        required_fields = ['name', 'phone', 'location', 'title', 'issue']
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing {field}"}), 400

        request_id = str(uuid.uuid4())

        service_request = {
            "type": "Service",
            "name": data["name"],
            "phone": data["phone"],
            "location": data["location"],
            "title": data["title"],
            "issue": data["issue"],
            "request_id": request_id,  
        }

        mongo.db.requests.insert_one(service_request)

        return jsonify({"message": "Service request submitted successfully", "request_id": request_id}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/request_installation', methods=['POST'])
@requires_auth
def request_installation():
    try:
        data = request.json

        required_fields = ['name', 'phone', 'location']
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing {field}"}), 400

        request_id = str(uuid.uuid4())

        installation_request = {
            "type": "Installation",
            "name": data["name"],
            "phone": data["phone"],
            "location": data["location"],
            "request_id": request_id,  
        }

        mongo.db.requests.insert_one(installation_request)

        return jsonify({"message": "Installation request submitted successfully", "request_id": request_id}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/get_requests', methods=['GET'])
def get_requests():
    try:

        object_id_str = request.args.get('user_id')  
        if not object_id_str:
            return jsonify({"error": "User ID is required"}), 400

        try:
            object_id = ObjectId(object_id_str)  
        except Exception as e:
            return jsonify({"error": "Invalid ObjectId format"}), 400

        provider = mongo.db.service_providers.find_one({"_id": object_id})  

        if not provider:
            return jsonify({"error": "Service provider not found"}), 404

        service_type = provider.get("service_type")

        if service_type not in ['Both', 'Installation', 'Service']:
            return jsonify({"error": "Invalid service type"}), 400

        if service_type == 'Both':
            requests = list(mongo.db.requests.find({}))  
        else:
            requests = list(mongo.db.requests.find({"type": service_type})) 

        requests = [
            {key: str(value) if key == "_id" else value for key, value in req.items()}
            for req in requests
        ]

        return jsonify({"requests": requests}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get_complaints', methods=['POST'])
def get_complaints():
    try:
        data = request.get_json()
        request_ids = data.get("request_ids", [])

        if not request_ids:
            return jsonify({"message": "No request IDs provided"}), 400

        complaints = list(requests_collection.find({"request_id": {"$in": request_ids}}, {"_id": 0}))
        
        return jsonify({"complaints": complaints}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

###################################################################################################################
def recommend_panel_type(power_input, space_input):
    if power_input == "Less than 400 units" and space_input == "Less space":
        return "monocrystalline"
    elif power_input == "More than 400 units" and space_input == "Less space":
        return "monocrystalline"
    elif power_input == "Less than 400 units" and space_input == "More space":
        return "polycrystalline, monocrystalline"
    elif power_input == "More than 400 units" and space_input == "More space":
        return "polycrystalline"
    else:
        return "Invalid input"

@app.route('/recommend', methods=['POST'])
def recommendation():
    try:
        data = request.get_json()
        power_input = data.get('electricity_consumption')
        space_input = data.get('roof_space')

        if not power_input or not space_input:
            return jsonify({'error': 'Missing required inputs'}), 400

        recommendation = recommend_panel_type(power_input, space_input)

        return jsonify({'recommendation': recommendation}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

############################################################################################################

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

    times = pd.date_range(current_date, periods=1, freq='D', tz='UTC')  
    location = pvlib.location.Location(latitude=lat, longitude=lon)
    clearsky = location.get_clearsky(times)  
    ghi = clearsky['ghi'].mean()

    panel_area = 1.6  
    efficiency = 0.18 
    solar_potential = ghi * panel_area * efficiency  

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

#######################################################################################################################################

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000, threaded=False)
