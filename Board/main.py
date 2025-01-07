import time
import network
import machine
import ujson
import usocket
import dogcommands

from dogcommands import StopCommand, ComeBack, Danger, DropIt, Sit, Off, Stay, No, Quiet

def process_command(command):
    # Define the switch dictionary
    switch = {
        "STOP": utils.StopCommand,
        "COME HERE": utils.ComeBack,
        "DANGER": utils.Danger,
        "DROP IT": utils.DropIt,
        "SIT": utils.Sit,
        "OFF": utils.Off,
        "STAY": utils.Stay,
        "NO": utils.No,
        "QUIET": utils.Quiet,
    }
    
    # Look up the command and execute the corresponding function
    action = switch.get(command)
    if action:
        action()  # Call the function
    else:
        print(f"Unknown command: {command}")
        
        
wifi=network.WLAN(network.STA_IF)
time.sleep(.5)
wifi.active(True)
time.sleep(.5)
wifi.connect('xxx', 'xxx')
cnt=0
while wifi.isconnected()==False:
    print('Waiting . . .')
    time.sleep(1)
    cnt=cnt+1
    
wifiInfo=wifi.ifconfig()
#print(wifiInfo)
UDP_IP=wifiInfo[0]
UDP_PORT=2222
# Create a UDP socket
sock = usocket.socket(usocket.AF_INET, usocket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

while True:
    try:
        # Receive data (max 1024 bytes)
        data, addr = sock.recvfrom(1024)
        print(f"Received data from {addr}: {data}")

        # Decode and parse JSON
        json_data = ujson.loads(data.decode('utf-8'))
        if "command" in json_data:
            cmd_name = json_data["command"]
            print(f"Received command: {cmd_name}")
            process_command(cmd_name)
        else:
            print("Invalid JSON structure: 'command' key missing")
    except ValueError:
        print("Failed to parse JSON")
    except Exception as e:
        print(f"Error: {e}")