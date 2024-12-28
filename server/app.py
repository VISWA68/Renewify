from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from bson import ObjectId
from flask_cors import CORS
import logging
from dotenv import load_dotenv

app = Flask(__name__)

# MongoDB Configuration
app.config["MONGO_URI"] = os.getenv('URL')
mongo = PyMongo(app)
CORS(app)

# Collections
users_collection = mongo.db.users
sellers_collection = mongo.db.sellers
shops_collection = mongo.db.shops
products_collection = mongo.db.products

# Helper function to serialize ObjectId
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

        # Check for missing fields
        required_fields = ['name', 'email', 'password', 'phone']
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing {field}"}), 400

        # Check if email already exists
        if users_collection.find_one({"email": data["email"]}):
            return jsonify({"error": "Email already exists"}), 400

        # Create seller user
        user = {
            "name": data["name"],
            "email": data["email"],
            "password": data["password"],  # Hash password in production
            "phone": data["phone"]
        }
        user_id = users_collection.insert_one(user).inserted_id

        # Create seller profile
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


@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json

        # Validate user
        user = users_collection.find_one({"email": data["email"]})
        if not user or user["password"] != data["password"]:  # Use hashed passwords in production
            return jsonify({"error": "Invalid credentials"}), 401

        # Fetch seller profile
        seller = sellers_collection.find_one({"email": data["email"]})
        if not seller:
            return jsonify({"error": "Seller profile not found"}), 404

        # Check if seller has shops
        shop = shops_collection.find_one({"seller_id": str(seller["_id"])})

        response = {
            "message": "Login successful",
            "seller_id": str(seller["_id"]),
        }

        if shop:
            response["shop_id"] = str(shop["_id"])  # Include shop_id if shop exists

        return jsonify(response), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/add_shop', methods=['POST'])
def create_shop():
    try:
        data = request.json

        # Validate seller
        seller = sellers_collection.find_one({"_id": ObjectId(data["seller_id"])})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        # Generate the shop_id
        shop_id = ObjectId()

        # Create shop with the shop_id included
        shop = {
            "_id": shop_id,  # Explicitly set the shop_id
            "seller_id": data["seller_id"],
            "shop_name": data["shop_name"],
            "address": data["address"],
            "upi_id": data["upi_id"],
            "shop_image": data.get("shop_image", ""),  # Optional field
        }

        # Insert shop into the shops collection
        shops_collection.insert_one(shop)

        # Update the seller with the shop_id
        sellers_collection.update_one(
            {"_id": ObjectId(data["seller_id"])},
            {"$push": {"shops": str(shop_id)}}
        )

        # Return the full shop object in the response
        return jsonify({
            "message": "Shop created successfully",
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/add_product', methods=['POST'])
def add_product():
    try:
        data = request.json
        print(f"Incoming request: {data}")
        # Validate shop
        shop = shops_collection.find_one({"_id": ObjectId(data["shop_id"])})
        if not shop:
            return jsonify({"error": "Shop not found"}), 404

        # Validate seller
        seller = sellers_collection.find_one({"_id": ObjectId(data["seller_id"])})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        # Create product
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
def get_shops_by_seller(seller_id):
    try:
        # Validate seller
        seller = sellers_collection.find_one({"_id": ObjectId(seller_id)})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        # Fetch shops and their products
        shops = list(shops_collection.find({"seller_id": seller_id}))
        for shop in shops:
            products = list(products_collection.find({"shop_id": str(shop["_id"])}))
            shop["products"] = serialize_object_id(products)

        return jsonify({"shops": serialize_object_id(shops)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/shops', methods=['GET'])
def get_all_shops():
    try:
        # Fetch all shops from the collection
        shops = list(shops_collection.find({}))

        # Convert ObjectId to string and format the response
        shops_data = []
        for shop in shops:
            # Fetch products associated with this shop
            shop_id = str(shop["_id"])
            products = list(products_collection.find({"shop_id": shop_id}))

            # Format product details
            products_data = [
                {
                    "name": product.get("name", ""),
                    "price": float(product.get("price", 0.0)),  # Ensure price is returned as float
                    "image": product.get("image", "")
                }
                for product in products
            ]

            # Format shop data
            shop_data = {
                "_id": shop_id,
                "shop_name": shop.get("shop_name", ""),
                "address": shop.get("address", ""),
                "upi_id": shop.get("upi_id", ""),
                "seller_id": str(shop.get("seller_id", "")),
                "products": products_data,
                "shop_image": shop.get("shop_image", "")
            }
            shops_data.append(shop_data)

        return jsonify({"message": "Shops retrieved successfully", "shops": shops_data}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500




@app.route('/seller/<string:seller_id>', methods=['GET'])
def get_seller_details(seller_id):
    try:
        # Fetch seller information
        seller = sellers_collection.find_one({"_id": ObjectId(seller_id)})
        if not seller:
            return jsonify({"error": "Seller not found"}), 404

        # Fetch shop details associated with the seller
        shops = list(shops_collection.find({"seller_id": seller_id}))
        for shop in shops:
            # Fetch products associated with each shop
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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000, threaded=False)
