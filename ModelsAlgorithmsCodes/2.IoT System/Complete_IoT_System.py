import time
import random
import requests
import africastalking
import Adafruit_DHT
import serial
import pynmea2
from datetime import datetime

# Setup Africa's Talking API setup
AT_USERNAME = "lsat_username"  
AT_API_KEY = "lsat_api_key"  
africastalking.initialize(AT_USERNAME, AT_API_KEY)
sms = africastalking.SMS

# Cloud server URL (mock for demonstration)
CLOUD_SERVER_URL = "https://lsat.sampleserver.com/api/v1" #This was brought down due to monetary mainataince costs it attracted.

# Sensor setup
DHT_SENSOR = Adafruit_DHT.DHT11
DHT_PIN = 4  # GPIO pin for DHT11
GPS_PORT = "/dev/ttyS0"  # Serial port for GPS (Neo-6M)

# Threshold for LSAT to trigger SMS (based on HAB conditions)
LSAT_THRESHOLD = 28.0  # Temp in °C (This is adjusted based on the study areas LSAT Thresholds)

# Simulate salinity sensor (This was removed due to lack of the sensor during study, recommendations were made.)
def get_salinity():
    return "NOT_SET"
    
# Simulate system power level and water condition
def get_system_status():
    try:
        with open('/sys/class/power_supply/battery/voltage_now', 'r') as file:
            voltage = float(file.read().strip()) / 1000000  # Convert microvolts to volts
        max_voltage = 4.2  # Max for LiPo battery
        min_voltage = 3.3  # MIn for Raspberry Pi
        percentage = ((voltage - min_voltage) / (max_voltage - min_voltage)) * 100
        return max(0, min(100, round(percentage, 2)))
    except Exception:
        return None


# Get LSAT using DHT11
def get_lsat():
    humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)
    if temperature is not None:
        return temperature
    return 0.0  # Fallback if reading fails

# Get GPS coordinates using Neo-6M
def get_gps_location():
    try:
        ser = serial.Serial(GPS_PORT, 9600, timeout=1)
        for _ in range(10):  # Try 10 times to get a valid GPS fix
            line = ser.readline().decode('utf-8').strip()
            if line.startswith('$GPGGA'):
                msg = pynmea2.parse(line)
                if msg.lat and msg.lon:
                    lat = float(msg.lat) / 100  # Convert to decimal degrees
                    lon = float(msg.lon) / 100
                    return lat, lon
    except Exception as e:
        print(f"GPS Error: {e}")
    return -1.059932, 37.01833  # Default fallback coordinates.

# Send data to cloud server
def send_to_cloud(data):
    try:
        response = requests.post(CLOUD_SERVER_URL, json=data)
        if response.status_code == 200:
            print("Sensor data sent to cloud successfully!")
            return True
        else:
            print(f"Failed to send data: {response.status_code}")
    except Exception as e:
        print(f"Cloud Transmission Error: {e}")
    return False

# Send SMS via Africa's Talking API
def send_sms_alert(message):
    try:
        recipients = ["+254 (0)-12-3456-789"]  # Replace with Maritime Authority phone number
        response = sms.send(message, recipients)
        print(f"SMS Sent: {response}")
    except Exception as e:
        print(f"SMS Error: {e}")

# Main data collection and transmission loop
def main():
    while True:
        # Collect data
        lsat = get_lsat()
        salinity = get_salinity()
        lat, lon = get_gps_location()
        power_level, water_condition = get_system_status()
        timestamp = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S GMT")

        # Prepare data for transmission
        data = {
            "lsat": lsat,
            "salinity": salinity,
            "location": {"lat": lat, "lon": lon},
            "power_level": power_level,
            "water_condition": water_condition,
            "timestamp": timestamp
        }

        # Send to cloud
        if send_to_cloud(data):
            # Check if LSAT exceeds threshold for HAB alert
            if lsat > LSAT_THRESHOLD:
                message = (f"LSAT abnormally detected! Temp: {lsat:.1f} °C, Lake Surf. Air, "
                          f"Water Salinity: {salinity}, Sensors Location: {lat:.6f}, {lon:.6f}, "
                          f"View Map: https://www.google.com/maps?q={lat:.6f},{lon:.6f}, "
                          f"System Power Level: {power_level}%, Water conditions: {water_condition}")
                send_sms_alert(message)

        # Wait 1 hour before next sample.
        time.sleep(3660)

if __name__ == "__main__":
    main()
