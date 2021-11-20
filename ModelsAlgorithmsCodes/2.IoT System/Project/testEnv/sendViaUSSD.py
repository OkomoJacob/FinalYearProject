# This code is correct and all is well.No bugs
import africastalking as at

sms_username = "myTrial"
sms_api_key = "c667670a2a2b2df9812f5421405d1dff0ba12544b502548eef5b2c5b147e5042"
at.initialize(sms_username,sms_api_key)
recepients = recipients = ['+254705583483']

def send_sms():
    sms = at.SMS
    response = sms.send("Test", recepients)
    print(response)

# main meat execution    
send_sms()
'''
[
        "Air Temperature: 23.08 °C.\
        Water Salinity Condition: NOT_SET.\
        Sensors Location: -1.09392, 37.01833. View Map: https://www.google.com/maps?q=-1.09392,37.01833.\
        System Power Level: 77%.\
        Water conditions: OK!"
     ]
'''