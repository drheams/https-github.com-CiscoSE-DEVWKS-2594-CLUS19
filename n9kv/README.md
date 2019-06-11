# Setting up Nexus 9000v using Vagrant

## Nexus 9000v Vagrant Box

Download **nxosv-final.9.2.3.box** from cisco.com to this directory

    vagrant box add base nxos.9.2.3.box
    vagrant up

## Configure the NXOSv image for NXAPI and boot variable

    printf "conf t\nfeature nxapi\nend" | vagrant ssh
    printf "conf t\nboot nxos bootflash:nxos.9.2.3.bin\nend" | vagrant ssh
    printf "conf t\ncopy run start\nexit" | vagrant ssh

## Cautions

Please note that you will get an error about session timing
out or /vagrant sync not working.  This is okay for the purposes of
this lab.
