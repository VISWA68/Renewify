from flask import Flask, render_template, request, jsonify,url_for
import cv2
import numpy as np
from shapely.geometry import Polygon
from PIL import Image, ImageDraw
from io import BytesIO
import requests
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
# latitude = 13.055177
# longitude = 80.076801

latitude = 13.047233
longitude = 80.074266
API_KEY = os.getenv('APIKEY')
area = 0.0
polygon_points = []



def convert_points(points):
    return [(int(point[0]), int(point[1])) for point in points]

def get_satellite_image(lat, lng, zoom=20, size="640x640"):
    static_map_url = f'https://maps.googleapis.com/maps/api/staticmap?center={lat},{lng}&zoom={zoom}&size={size}&maptype=satellite&key={API_KEY}'
    response = requests.get(static_map_url)
    response.raise_for_status()
    image = Image.open(BytesIO(response.content))
    return image

def calculate_gsd(lat, zoom):
    earth_circumference = 40075016.686
    lat_rad = np.radians(lat)
    meters_per_pixel = earth_circumference * np.cos(lat_rad) / (2 ** zoom * 256)
    feet_per_pixel = meters_per_pixel * 3.28084
    return feet_per_pixel

@app.route('/')
def landing():
    global latitude, longitude
    latitude = request.args.get('latitude', latitude, type=float)
    longitude = request.args.get('longitude', longitude, type=float)
    return render_template('landing.html')

@app.route('/index')
def index():
    zoom_level = 21
    image = get_satellite_image(latitude, longitude, zoom=zoom_level)
    image_path = "static/satellite_image.png"
    image.save(image_path)
    return render_template('index.html', image_url=image_path)

@app.route('/bipv')
def bipv():
    geojson_url = url_for('static', filename='data/buildings_with_centroids_id.geojson')
    return render_template('bipv.html', geojson_url=geojson_url)

@app.route('/get_lat_long', methods=['POST'])  # Change to POST
def lat_long():
    global latitude, longitude
    if request.is_json:
        get_data = request.json
        # latitude = get_data.get('a')  # Use .get to safely retrieve keys
        # longitude = get_data.get('b')
        print(f"Latitude: {latitude}, Longitude: {longitude}")
        return jsonify({"status": "success", "latitude": latitude, "longitude": longitude}), 200
    else:
        return jsonify({"error": "Invalid Content-Type. Expected application/json."}), 400

@app.route('/calculate_area', methods=['POST'])
def calculate_area():
    data = request.json
    points = data['points']
    latitude = data['latitude']
    zoom_level = 21
    points = [(float(point[0]), float(point[1])) for point in points]
    poly = Polygon(points)
    area_in_pixels = poly.area
    feet_per_pixel = calculate_gsd(latitude, zoom_level)
    area_in_square_feet = area_in_pixels * (feet_per_pixel ** 2)
    global area
    area = area_in_square_feet
    return jsonify({"area": area_in_square_feet})

@app.route('/cut_polygon', methods=['POST'])
def cut_polygon():
    data = request.json
    points = data['points']
    points = [(int(point[0]), int(point[1])) for point in points]
    image = Image.open("static/satellite_image.png").convert("RGBA")
    mask = Image.new('L', (image.width, image.height), 0)
    ImageDraw.Draw(mask).polygon(points, outline=1, fill=1)
    mask = np.array(mask)
    image_np = np.array(image)
    alpha_channel = np.zeros_like(image_np[:, :, 0])
    alpha_channel[mask == 1] = 255
    image_np = np.dstack((image_np[:, :, :3], alpha_channel))
    new_image = Image.fromarray(image_np, 'RGBA')
    output_path = "static/cut_polygon.png"
    new_image.save(output_path)
    return jsonify({"image_url": output_path})

def extract_polygon_points2(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)
    if image.shape[2] == 4:
        b, g, r, a = cv2.split(image)
        mask = a
    else:
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        _, mask = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    contour = max(contours, key=cv2.contourArea)
    epsilon = 0.02 * cv2.arcLength(contour, True)
    approx = cv2.approxPolyDP(contour, epsilon, True)
    corner_points = approx.reshape(-1, 2)
    return corner_points

@app.route('/get_polygon_points')
def get_polygon_points():
    image_path = 'static/cut_polygon.png'
    polygon_points = convert_points(extract_polygon_points2(image_path))
    if not polygon_points:
        return jsonify({"error": "No points found"}), 404
    return jsonify({"points": polygon_points})

@app.route('/solar_panels')
def solar_panels():
    no_of_panels = int(area / 17.62) - int((int(area / 17.62) * 0.285))
    return render_template('solar_panels.html', panel_count=no_of_panels)


@app.route('/calculate')
def calculate():
    return render_template('solar.html')
    data = request.json
    num_panels = int(data.get('num_panels', 4))
    calculated_data = calculate_data(num_panels)

    # Pass calculated_data to the templat

def calculate_data(num_panels):
    capacity = num_panels * 1.7
    cost_per_panel = 46000
    project_cost = num_panels * cost_per_panel
    subsidy_rate = 0.42
    subsidy = project_cost * subsidy_rate
    consumer_share = project_cost - subsidy
    payback_period = 5 + (capacity * 0.1)
    return_on_investment = 20 + (capacity * 0.5)
    financial_savings_per_day = capacity * 12
    financial_savings_per_year = financial_savings_per_day * 365
    emission_savings = capacity * 1.5

    # Sample calculations for environmental impact
    cars_off_road = emission_savings / 4.6
    trees_planted = emission_savings * 15
    co2_reduction = emission_savings * 1.2

    return {
        "capacity": round(capacity, 2),
        "project_cost": round(project_cost, 2),
        "subsidy": round(subsidy, 2),
        "consumer_share": round(consumer_share, 2),
        "payback_period": round(payback_period, 2),
        "return_on_investment": round(return_on_investment, 2),
        "financial_savings_per_day": round(financial_savings_per_day, 2),
        "financial_savings_per_year": round(financial_savings_per_year, 2),
        "emission_savings": round(emission_savings, 2),
        "cars_off_road": round(cars_off_road, 2),
        "trees_planted": round(trees_planted, 2),
        "co2_reduction": round(co2_reduction, 2)
    }


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
