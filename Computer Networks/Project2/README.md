# C02 monitor peer to peer relay

## Steps to execute the files

### Step 1:

The alarm_server.py consists of a simulation of what CO2 levels might range in. Open a terminal window (1st window) and navigate to project directory,then execute `python3 alarm_server.py`.

### Step 2:

The alarm.client.py file consists of the major client to which data is being sent using TCP connection. Open another terminal window (2nd window) and navigate to project folder. Then execute `python3 alarm_client.py`.

### Step 3:

The following part showcases the peer to peer transfer of the data. Open another terminal window(3rd window) and navigate to the the project folder. After navigation, execute `python3 node.py`.

### Step 4:

This file acts as another peer. This recieves and sends data just like node.py. This file is used to showcase the UDP multicast relay of data. Open another terminal window (4th window) and navigate to the project folder. Then execute `python3 node2.py`.

### Step 5:

The data packets tranfer continuously until and unless the server shuts down. To quit the programs select the terminal window to quit and use the control+c keys to exit the program.

### Note:

1. The files alarm_server.py and alarm_client.py were executing perfectly on Pi. The node.py file and node2.py file use UDP multicast which is prone to not work on LINUX systems. Upon research it was found that the command `sudo ip route add 224.0.0.0/4 dev eth0` would fix the same, however, sudo access is not granted to us.

2. External dependencies or packages were not used in this project. All packages are included in the standard python library
