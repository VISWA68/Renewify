
# Rooftop Analysis and BIPV Analysis Module

This folder contains the **Rooftop Analysis** and **Building-Integrated Photovoltaic (BIPV) Analysis** module for the Renewify project. These tools are designed to help users visualize and analyze the solar potential of their buildings using advanced technologies like **Flask** and **Three.js**.

---

## 🌟 Features

### 1. **Rooftop Analysis**
- **Satellite View Integration**: Displays a satellite image of the user's current building location.
- **Interactive Solar Panel Placement**:
  - Users can select and draw areas on the rooftop where solar panels should be installed.
  - Real-time visualization using **Three.js**.
- **Power Output Calculation**: Dynamically calculates the estimated power output as the number of panels increases.

### 2. **BIPV Analysis**
- **3D Building Visualization**:
  - Users can visualize a detailed 3D model of their building using **Three.js**.
- **Sun and Shadow Analysis**:
  - Simulates the building's solar exposure based on sun position and shadow analysis.
- **Comprehensive Solar Potential Analysis**:
  - Calculates:
    - Total solar potential of the building.
    - Vertical solar potential.
    - Rooftop solar potential.

---

## 🛠️ Installation & Setup

### 1. Prerequisites
- Install Python 3.x and set up a virtual environment.
- Install Node.js for managing dependencies required for Three.js.

### 2. Setup the Backend (Flask)
1. Navigate to the `rooftop_analysis` folder.
2. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Start the Flask server:
   ```bash
   python app.py
   ```
4. The server will run at `http://localhost:5000`.

### 3. Setup the Frontend (Three.js)
1. Navigate to the `frontend` folder within `rooftop_analysis`.
2. Install Node.js dependencies:
   ```bash
   npm install
   ```
3. Start the frontend development server:
   ```bash
   npm run dev
   ```
4. Access the frontend interface at `http://localhost:3000`.

---

## 🔄 Workflow

### **Rooftop Analysis**
1. Launch the application and click **Rooftop Analysis**.
2. A satellite image of the current location is displayed.
3. Use the interactive tools to:
   - Mark areas on the rooftop where solar panels will be placed.
   - Visualize solar panel placement in 3D.
4. Adjust the number of panels to see real-time power output estimation.

### **BIPV Analysis**
1. Click **BIPV Analysis**.
2. A 3D model of the building is rendered.
3. Analyze:
   - Shadow and sun position throughout the day.
   - The solar potential of the rooftop and vertical surfaces.
4. Receive detailed metrics for total solar potential, vertical potential, and rooftop potential.

---

## 📊 Outputs
- **Power Output Estimation**: Based on the number of panels and their placement.
- **Solar Potential Metrics**:
  - Total Solar Potential (kWh/year)
  - Rooftop Solar Potential (kWh/year)
  - Vertical Solar Potential (kWh/year)

---

## 📄 License

This module is part of the Renewify project and is licensed under the MIT License. See the main repository's [LICENSE](../LICENSE) for details.

---

Harness the power of data and visualization for optimal solar energy planning! 🌞
