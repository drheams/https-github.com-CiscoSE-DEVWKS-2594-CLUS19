# Setting up Nexus 9000v using Vagrant

## Nexus 9000v Vagrant Box

Download **nxosv-final.9.2.3.box** from cisco.com to this directory

```bash
vagrant box add base nxos.9.2.3.box
vagrant up
```

## Configure the NXOSv image for NXAPI and boot variable

```bash
bash -x enable_nxapi.sh
```

## For this workshop, you need to enable icam

```bash
python3 setup_nxos.py
```

## Cautions

Please note that you will get an error about session timing
out or /vagrant sync not working.  This is okay for the purposes of
this lab.
