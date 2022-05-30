# Hybrid Protocol Irrigation network

## Steps to execute the files

### Step 1:

The server.py consists of a simulation of various dictionary objects.These objects contain the information which we might get from irrigation server. Open a terminal window (1st window) and navigate to project directory,then execute `python3 server.py`.

### Step 2:

The central_node.py file consists of the major client to which data is being sent using TCP connection. Open another terminal window (2nd window) and navigate to project folder. Then execute `python3 central_node.py`.

### Step 3:

The following part showcases the peer to peer transfer of the data. Open another terminal window(3rd window) and navigate to the the project folder. After navigation, execute `python3 node.py`.

### Step 4:

This file acts as another peer. This receives and sends data just like node.py. This file is used to showcase the UDP multicast relay of data. Open another terminal window (4th window) and navigate to the project folder. Then execute `python3 node2.py`.

### Step 5:

The data packets tranfer continuously until and unless the server shuts down. To quit the programs select the terminal window to quit and use the control+c on windows/linux and command+c on mac key to exit the program on each.

### Note:

1. The files server.py, central_node.py and node.py were executing perfectly on Pi.The node2.py file use UDP multicast which is prone to not work on LINUX systems. Upon research it was found that the command `sudo ip route add 224.0.0.0/4 dev eth0` would fix the same, however, sudo access is not granted to us.

2. External dependencies or packages were not used in this project. All packages are included in the standard python library

3. The project directory also contains a screenshot of the code being run Raspberry Pi's 012 and 032.

4. The sockets present in the central_node.py require the IP address of the server. Kindly check the comments for using the appropriate socket creation.

5. The test cases simply comprises of the various dictionary objects and will run every 2 seconds.
