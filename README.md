Digi Remote Manager Web Proxy
==============================

This repository provides an example of how to setup a Squid Web Proxy to proxy
traffic from Digi devices to Digi Remote Manager.

Also provided is a Docker container that will help get you started quickly.

Digi recommends reviewing, understanding, and testisg your entire squid
configuration file before deploying it for use by devices in the field.

## Run the example Docker container
------------------------------------
Running the example container can be done with the following steps.
_(These steps have only been tested in Ubuntu >=18.04)_

1. Confirm Docker is installed
   See <https://docs.docker.com/engine/install/> for instructions on how to
   install

2. Clone this repo
```
	$ git clone <my_link> && cd <repo>
```

3. Build the container
```
	$ docker build -t rm-squid-proxy:0.7 .
```

4. Start the container using the helper script.
   This will start the docker container using the squid.conf file located in
   this repository.
```
	$ ./start_docker_squid.sh`
```

5. Test your proxy
```
	$ curl -x localhost:3128 https://www.google.com
```

6. Configure your device to connect to Digi Remote Manager through your new
   proxy server. The address of the proxy is your computer's address, and the
   port is 3128.


## Customize the example Docker container
------------------------------------------
The Squid configuration can be modified without rebuilding the container.

1. To create your own config, copy the file and edit it with your favorite text
   editor.
```
	$ cp squid.conf custom.conf
	$ vim custom.conf
```

2. Once your changes are complete you can start a new container.

   __WARNING:__ The whole directory the custom configuration file is in will be
   mounted and available in the docker container. It is recommended to place the
   configuration file in its own directory.
```
	$ ./start_docker_squid.sh -f custom.conf`
```

- If you changed the `http_port` in your custom config file you must specify it
when running the start script.
```
	$ ./start_docker_squid.sh -p 8000 -f custom.conf`
```

- Multiple ports can be specified with multiple `-p flags`
```
	./start_docker_squid -p 8000 -p 8080 -p 443 -f custom.conf`
```

- Use the `-r` flag to automatically remove the container when it stops, this can
speed up the debugging process
```
	$ ./start_docker_squid.sh -p 3128 -f custom.conf -r`
```

## Connect to Digi Remote Manager using only Port 443
------------------------------------------------------
1. Start the container using using the _443.conf_ file. This file may need to be
   modified to work with your devices.
```
	$ ./start_docker_squid.sh -p 443 -f 443.conf
```

2. Configure your device to connect to `2my.devicecloud.com:443` through the
   proxy. See your device's user guide for how to do this.

## License
-----------
This software is open-source. Copyright (c), Digi International Inc., 2020.

This Source Code Form is subject to the terms of the Mozilla Public License, v.
2.0. If a copy of the MPL was not distributed with this file, you can obtain one
at <http://mozilla.org/MPL/2.0/>.
