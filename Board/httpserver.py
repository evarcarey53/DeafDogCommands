import network
import socket
import time
import ujson

# Connect to Wi-Fi
ssid = ""
password = ""

wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(ssid, password)

# Wait for the connection
while not wlan.isconnected():
    time.sleep(1)

print("Connected to Wi-Fi:", wlan.ifconfig())

# Create a basic HTTP server
def web_server():
    addr = socket.getaddrinfo('0.0.0.0', 80)[0][-1]
    s = socket.socket()
    s.bind(addr)
    s.listen(1)
    print('Listening on', addr)

    while True:
        cl, addr = s.accept()
        print('Client connected from', addr)
        request = cl.recv(1024)

        # Process the request to check for POST data
        if b"POST" in request:
            data = request.split(b"\r\n\r\n")[1]  # Extract data
            try:
                json_data = ujson.loads(data)
                print("Received data:", json_data)
            except ValueError:
                print("Invalid JSON data")
        
        # Send a response back to the iOS app
        response = """HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n
        <html><body><h1>Data received!</h1></body></html>"""
        cl.send(response)
        cl.close()

web_server()
