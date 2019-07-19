#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import paho.mqtt.client as mqtt
import ssl
import json
from time import sleep
from datetime import datetime

host = sys.argv[1]
port = 8883
cacert = 'AmazonRootCA1.pem'
clientCert = 'cert.pem'
clientKey = 'private-key.pem'

topic = 'foo/bar'
data = {"clientid":0, "timestamp":0, "battery_level":0, "temperature_value": 25, "temperature_unit": "degc"}

def on_connect(client, userdata, flags, respons_code):
    print('status {0}'.format(respons_code))

def on_disconnect(client, userdata, rc):
    if rc != 0:
        print("Unexpected disconnection.")

def on_publish(client, userdata, mid):
    print("published")

if __name__ == '__main__':
    client = mqtt.Client()
    client.tls_set(ca_certs=cacert,
            certfile = clientCert,
            keyfile = clientKey,
            tls_version = ssl.PROTOCOL_TLSv1_2)
    client.tls_insecure_set(True)

    ### callback function
    client.on_connect = on_connect
    client.on_publish = on_publish

    client.connect(host, port=port, keepalive=60)
    client.loop_start()
    sleep(3)
    while True:
        data["timestamp"] = int(datetime.now().strftime('%s'))
        message = json.dumps(data)
        client.publish(topic, message)
        sleep(1)
