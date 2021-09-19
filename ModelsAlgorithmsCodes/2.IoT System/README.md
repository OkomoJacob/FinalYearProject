# LSAT IoT Monitoring System
## Overview

This project implements a real-time environmental monitoring system designed to detect Harmful Algal Blooms (HABs) in lake ecosystems. It collects data on Lake Surface Air Temperature (LSAT), salinity, GPS location, system power level and water condition, transmitting this data to a cloud server and sending SMS alerts when LSAT exceeds a predefined threshold.

### Features
 - [X] `Temperature Monitoring:` Measures LSAT using a DHT11 sensor.
 - [X] `GPS Tracking:` Captures location data with a Neo-6M GPS module.
 - [X] `Cloud Integration:` Sends data to a cloud server via HTTP POST requests.
 - [X] `SMS Alerts:` Uses Africa's Talking API to send alerts when LSAT indicates potential HAB conditions.
 - [X] `System Status:` Monitors power level and water condition with simulated values.

## Hardware Requirements 

 - [X] Raspberry Pi Model 3 B+
 - [X] DHT11 Sensor: For temperature and humidity measurements (connected to GPIO pin 4).
 - [X] Neo-6M GPS Module: For location data (connected to serial port /dev/ttyS0).
 - [X] Internet Connection: For cloud data transmission and SMS alerts.
 - [X] Power Supply: Stable power source for continuous operation.

## Software Requirements

Python 3.2+
### Libraries:

`Adafruit_DHT:` For DHT11 sensor interfacing.
`pynmea2:` For parsing GPS NMEA data.
`requests:` For HTTP requests to the cloud server.
`africastalking:` For SMS alerts via Africa's Talking API.
`pyserial:` For serial communication with the GPS module.


Operating System: Linux-based (e.g., Raspberry Pi OS).

## Installation

Clone the Repository:
git clone https://github.com/OkomoJacob/FinalYearProject.git
Navigate to this directory and locate `Complete_IoT_System.py` file


## Install Dependencies:
```shell
$ pip install -r requirements.txt
```

### Set Up Africa's Talking API:

Sign up at Africa's Talking & obtain your AT_USERNAME and AT_API_KEY.
Update the script with these credentials: AT_USERNAME = "lsat_username"
AT_API_KEY = "lsat_api_key"


### Hardware Configuration.

- Connect the DHT11 sensor to GPIO pin 4.
- Connect the Neo-6M GPS module to the serial port /dev/ttyS0.

Run the Script:
On power on, the system is configured to automatically start data transmission

### Configuration

### Usage

Once powered, the system runs continuously, collecting data every 3600 seconds (1 Hour or as desired).
Data is sent to the configured cloud server.
If LSAT exceeds the threshold, an SMS alert is sent with temperature, salinity, location, and system status details, including a Google Maps link.

### Data Format
```json
The system sends JSON data to the cloud server in the following format:
{
  "lsat": 25.5,
  "salinity": "NOT_SET",
  "location": {
    "lat": -1.059932,
    "lon": 37.01833
  },
  "power_level": 85,
  "water_condition": "OK",
  "timestamp": "2021-05-07 12:34:56 GMT"
}
```
## Limitations

Salinity Sensor: Currently a placeholder (NOT_SET). Integrate a real salinity sensor for complete functionality.
Mock Cloud Server: The CLOUD_SERVER_URL is a placeholder. Replace with a real endpoint.
Power Level Simulation: Power level and water condition are simulated. Integrate actual sensors for production use.
Error Handling: Basic error handling is implemented; enhance for robustness in production environments.

Contributing
Contributions are welcome! Please:

Fork the repository.
Create a feature branch (git checkout -b feature/your-feature).
Commit your changes (git commit -m "Add your feature").
Push to the branch (git push origin feature/your-feature).
Open a pull request.

### License
This project is licensed under the MIT License. See the LICENSE file for details.
### Acknowledgments

- Africa's Talking for SMS API services.
- Adafruit for DHT sensor libraries.
- The environmental science community for HAB research informing this project.

