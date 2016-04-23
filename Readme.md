# How to build the Docker image and generate a container

### Step 1
Git clone, and unarchive the zip in the files folder.

### Step 2
Start a Docker terminal, cd at the Dockerfile and build the image:
```docker build -t esb .```

### Step 3
Generate a container: 
```cf ic run -P --name local_esb esb```

Note: The ```-P``` option publishes all the ports to the host interfaces. Docker will bind each exposed port to a random port on the host. Run ```docker port local_esb``` to see the assigned ports, and ```docker-machine ip``` to see the VM's assigned local IP.

### Step 4
Start and attach to the container with: ```docker start -a local_esb```

### Step 5
Finally, ```./run.sh``` to start the eventserver at port ```7000``` and prediction engine at port ```8000```.