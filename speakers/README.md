# Student Setup Instruction

```bash
cd ${HOME}/workspace/DEVWKS-2594-CLUS19
git pull
cd n9kv

# Ensure your Nexus 9000v environment is running
vagrant ssh
# Should get a "Nexus9000v#" prompt
exit

# Setup Python environment
pip install virtualenv

virtualenv -p $(which python3) ${HOME}/workspace/env
source ${HOME}/workspace/env/bin/activate
pip install -r ${HOME}/workspace/DEVWKS-2594-CLUS19/requirements.txt

# Configure you Nexus 9000v environment
bash enable_nxapi.sh
python3 setup_nxos.py

# Get Ready For Session
cd ${HOME}/workspace/DEVWKS-2594-CLUS19/nxapi_cli
```
