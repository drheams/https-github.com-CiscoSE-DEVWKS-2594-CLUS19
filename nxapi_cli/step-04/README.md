# Overview

This stage extends the script functionality to:
- Collect metrics related to VXLAN IP routes
- Leverage code abstractions and environment variables from step-03

## VXLAN Fabric

Leverages the "Open NX-OS with Nexus 9Kv" DEVNET Sandbox found at
[http://devnetsandbox.cisco.com/]

## Network Communication Diagram
<img src='images/Step04-Network-Communication.png' width='400px'>

## Containerization Steps

Build the Docker image for this command:

    docker build -t devnet-2594/step-04:latest -t devnet-2594/step-04:1 .

## Operational Deployment (local laptop)

Create a Docker network to which the containers will connect:

    docker run --name nx-osv9000-1 -d --network demo0 -p 127.0.0.1:8891:8888 \
            -e "NXAPI_HOST=172.16.30.101" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04
    docker run --name nx-osv9000-2 -d --network demo0 -p 127.0.0.1:8892:8888 \
            -e "NXAPI_HOST=172.16.30.102" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04
    docker run --name nx-osv9000-3 -d --network demo0 -p 127.0.0.1:8893:8888 \
            -e "NXAPI_HOST=172.16.30.103" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04
    docker run --name nx-osv9000-4 -d --network demo0 -p 127.0.0.1:8894:8888 \
            -e "NXAPI_HOST=172.16.30.104" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04

Deploy Prometheus container:

    docker run --name prometheus -d --network demo0 \
            -p 127.0.0.1:9090:9090 \
            -v ${PWD}/prometheus.yml:/etc/prometheus/prometheus.yml \
            quay.io/prometheus/prometheus

Deply Grafana container:

    docker run --name grafana -d --network demo0 \
            -p 127.0.0.1:3000:3000 \
            grafana/grafana

## If you'd like to run this on DEVBOX in the Sandbox

Create the new Docker bridge network **demo0**:

    docker network create --driver=bridge --subnet=192.168.254.0/24 \
                          --gateway=192.168.254.254 --attachable demo0

Build the Docker image for this command:

    docker build -t devnet-2594/step-04:latest -t devnet-2594/step-04:1 .

Create a Docker network to which the containers will connect:

    docker run --name nx-osv9000-1 -d --network demo0 -p 10.10.20.20:8891:8888 \
            -e "NXAPI_HOST=172.16.30.101" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04
    docker run --name nx-osv9000-2 -d --network demo0 -p 10.10.20.20:8892:8888 \
            -e "NXAPI_HOST=172.16.30.102" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04
    docker run --name nx-osv9000-3 -d --network demo0 -p 10.10.20.20:8893:8888 \
            -e "NXAPI_HOST=172.16.30.103" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04
    docker run --name nx-osv9000-4 -d --network demo0 -p 10.10.20.20:8894:8888 \
            -e "NXAPI_HOST=172.16.30.104" -e "NXAPI_PORT=80" \
            -e "NXAPI_USER=cisco" -e "NXAPI_PASS=cisco" \
            devnet-2594/step-04

Deploy Prometheus container:

    docker run --name prometheus -d --network demo0 \
            -p 10.10.20.20:9090:9090 \
            -v ${PWD}/prometheus.yml:/etc/prometheus/prometheus.yml \
            quay.io/prometheus/prometheus

Deply Grafana container:

    docker run --name grafana -d --network demo0 \
            -p 10.10.20.20:3000:3000 \
            grafana/grafana

Please note - while building the DEVNET Sandbox environment offers a lot of
convenience, it may take some time before the Prometheus container actually
shows collected data.  You can validate that Prometheus is functional and able
to connect to the Nexus 9000v collectors by visiting the
[Prometheus Target Status](http://10.10.20.20:9090/targets) page.  Each target
should have a status of "UP".

## Demonstration Waypoints

### Examine raw data within Prometheus

These Prometheus examples reference building the generation, collection, and Prometheus
components within the DEVNET Sandbox environment.  If you build it locally, simply
replace the IP address *10.10.20.20* with *127.0.0.1*

Open a web browser and connect to the Prometheus service running in a container -
http://10.10.20.20:9090/

1. Plot the counts of paths for each IP Prefix
   - Select **ip_prefix_path_count** from the dropdown list and click *Execute*

2. Plot data solely related to **leaf2**
   - Click *Add Graph* to add another graph
   - Enter **ip_prefix_path_count{job="nxapi_leaf2"}** into *Expression* box and click *Execute*

3. Plot the IP traffic for each interface
   - Click *Add Graph* to add another graph
   - Enter **ip_prefix_path_traffic** into *Expression* box and click *Execute*

### Examine dashboard approach within Grafana

Due to the limited resources of the Sandbox environment, the demos during Cisco Live
will spin up Grafana on the local laptop and we will configure the data source to
point into the Sandbox Prometheus environment.

Open a web browser and connect to the Grafance service running in a container -
http://127.0.0.1:3000/

1. Log into Grafana with default username/password : admin/admin
   - It will prompt for new password, simply re-use the admin password

2. First task is to add a data source.  Select Prometheus from the list.
   - In the URL box, enter http://10.10.20.20:9090/
   - Click *Save and Test* button at bottom

3. Import a sample dashboard for this workshop
   - Mouse-over the *+* icon along the left and select *Import*
   - Select the **grafana-4node.json** file from the step-04 directory
   - Click *Import* button

Explore each of the graphs in the dashboard.  Change the default time interval (1 hour)
to larger windows by clicking the *Last 1 hour* button in the upper right of the web page.

## References

A list of curated references for the technologies and demonstrations within
this stage of the presentation:

1. [Prometheus Querying Basic](https://prometheus.io/docs/prometheus/latest/querying/basics/)
