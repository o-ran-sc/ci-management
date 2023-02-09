echo "---> xtesting-verify.sh starts"
#install devstack

#git clone https://opendev.org/openstack/devstack
#cd devstack/tools
#sudo ./create-stack-user.sh
#cd ../..
#sudo mv devstack /opt/stack
#sudo chown -R stack.stack /opt/stack/devstack

sudo useradd -s /bin/bash -d /opt/stack -m stack
sudo chmod +x /opt/stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
sudo chown -R stack:stack /opt/stack
#cd /opt/stack/
pwd
whoami

sudo git clone https://opendev.org/openstack/devstack
sudo chown -R jenkins:jenkins devstack
sudo chmod -R 775 /opt/stack

cd devstack
pwd
ls -l
touch .localrc.password
#echo "SERVICE_PASSWORD=devstack" > .localrc.password
DEST="/opt/stack"
ip=$(hostname -I | awk '{print $1}')
sudo sh -c "echo '[[local|localrc]]\n############################################################\n# Customize the following HOST_IP based on your installation\n############################################################\nHOST_IP='$ip'\nADMIN_PASSWORD=devstack\nMYSQL_PASSWORD=devstack\nRABBIT_PASSWORD=devstack\nSERVICE_PASSWORD=$ADMIN_PASSWORD\nSERVICE_TOKEN=devstack\n############################################################\n# Customize the following section based on your installation\n############################################################\n\n# Pip\nPIP_USE_MIRRORS=False\nUSE_GET_PIP=1\n#OFFLINE=False\n#RECLONE=True\n# Logging\nLOGFILE=$DEST/logs/stack.sh.log\nVERBOSE=True\nENABLE_DEBUG_LOG_LEVEL=True\n\nENABLE_VERBOSE_LOG_LEVEL=True\n# Neutron ML2 with OpenVSwitch\nQ_PLUGIN=ml2\nQ_AGENT=ovn\n\n# Disable security groups\nLIBVIRT_FIREWALL_DRIVER=nova.virt.firewall.NoopFirewallDriver\n\n# Enable neutron, heat, networking-sfc, barbican and mistral\nenable_plugin neutron https://opendev.org/openstack/neutron master\nenable_plugin heat https://opendev.org/openstack/heat master\nenable_plugin networking-sfc https://opendev.org/openstack/networking-sfc master\nenable_plugin barbican https://opendev.org/openstack/barbican master\nenable_plugin mistral https://opendev.org/openstack/mistral master\n\n# Ceilometer\n#CEILOMETER_PIPELINE_INTERVAL=300\nenable_plugin ceilometer https://opendev.org/openstack/ceilometer master\nenable_plugin aodh https://opendev.org/openstack/aodh master\n\n# Blazar\nenable_plugin blazar https://github.com/openstack/blazar.git master\n# Fenix\nenable_plugin fenix https://opendev.org/x/fenix.git master\n\n# Tacker\nenable_plugin tacker https://opendev.org/openstack/tacker master\n\nenable_service n-novnc\nenable_service n-cauth\ndisable_service tempest\n# Enable kuryr-kubernetes, crio, octavia\nKUBERNETES_VIM=True\n# It is necessary to specify the patch version\n# because it is the version used when executing apt-get install command.\nKURYR_KUBERNETES_VERSION=\"1.25.2\"\nCONTAINER_ENGINE=\"crio\"\n# It is not necessary to specify the patch version\n# because it is the version used when adding the apt repository.\nCRIO_VERSION=\"1.25\"\nenable_plugin kuryr-kubernetes https://opendev.org/openstack/kuryr-kubernetes master\nenable_plugin octavia https://opendev.org/openstack/octavia master\nenable_plugin devstack-plugin-container https://opendev.org/openstack/devstack-plugin-container master\nenable_service kubernetes-master\nenable_service kuryr-kubernetes\nenable_service kuryr-daemon\n[[post-config|/etc/neutron/dhcp_agent.ini]]\n[DEFAULT]\nenable_isolated_metadata = True\n\n[[post-config|$OCTAVIA_CONF]]\n[controller_worker]\namp_active_retries=9999\nenable_service q-qos\nQ_SERVICE_PLUGIN_CLASSES=router,neutron.services.metering.metering_plugin.MeteringPlugin,networking_sfc.services.flowclassifier.plugin.FlowClassifierPlugin,neutron.services.qos.qos_plugin.QoSPlugin,qos\nQ_ML2_PLUGIN_EXT_DRIVERS=port_security,qos\nL2_AGENT_EXTENSIONS=qos' >> local.conf"

#sudo systemctl restart openvswitch-switch.service
#sudo -u stack  ./stack.sh
export FORCE="yes"
./stack.sh
#check if devstack is installed
end=$(sed -n -e '$p' /opt/stack/logs/stack.sh.log.summary)
string="stack.sh completed"
echo $string
if [[ $end == *"$string"* ]]; then
  echo "Continue"
else
  echo "devstack is not installed"
  exit 1
fi

#install xtesting
cd /opt/stack/tacker/tacker/tests
sudo rm -rf xtesting
sudo rm -rf /tmp/smo-o2
sudo mkdir xtesting
cd xtesting
virtualenv xtesting-py3 -p python3
. xtesting-py3/bin/activate
sudo pip install xtesting
cd /tmp
sudo git clone https://github.com/o-ran-sc/smo-o2
sleep 1
cd -
sudo cp /tmp/smo-o2/tacker/tacker/tests/xtesting/requirements.txt .
sudo pip install -r requirements.txt
sudo git clone https://forge.etsi.org/rep/nfv/api-tests.git
sudo cp -r /tmp/smo-o2/tacker/tacker/tests/xtesting/api-tests/SOL003/CNFDeployment ./api-tests/SOL003
sudo cp -r /tmp/smo-o2/tacker/tacker/tests/xtesting/api-tests/SOL003/cnflcm ./api-tests/SOL003
sudo cp -r /tmp/smo-o2/tacker/tacker/tests/xtesting/api-tests/SOL005/CNFPrecondition ./api-tests/SOL005
sudo cp /tmp/smo-o2/tacker/tacker/tests/xtesting/testcases.yaml ./xtesting-py3/lib/python3.8/site-packages/xtesting/ci/
sudo sudo chmod -R 775 api-tests

#preondition
sudo apt-get install dos2unix
sudo apt install jq --assume-yes

#vim-register
cd /opt/stack/
sudo rm vim_config.yaml
bash tacker/tools/gen_vim_config.sh -t k8s
val=default-token-k8svim
TOKEN=$(kubectl get secret $val -o jsonpath="{.data.token}" | base64 --decode) && echo $TOKEN
set -e
EXIT_CODE=0
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --serviceaccount=default:default || EXIT_CODE=$?
echo $EXIT_CODE
cert=$(kubectl get secrets $val -o jsonpath="{.data.ca\.crt}" | base64 --decode)
ip=$(hostname -I | awk '{print $1}')
curl -k https://$ip:6443/api/ -H "Authorization: Bearer $TOKEN"
echo 'auth_url: "https://'$ip':6443"
bearer_token: "'$TOKEN'"
ssl_ca_cert: "'"$cert"'"
project_name: "default"
type: "kubernetes"' >> vim_config.yaml

openstack vim register --config-file vim_config.yaml vim-kubernetes --is-default

#Install Helm
HELM_VERSION="3.10.0"  # Change to version that is compatible with your cluster
wget -P /tmp https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz
tar zxf /tmp/helm-v$HELM_VERSION-linux-amd64.tar.gz -C /tmp
sudo mv /tmp/linux-amd64/helm /usr/local/bin/helm

#Create directory to store Helm chart
HELM_CHART_DIR="/var/tacker/helm"
sudo mkdir -p $HELM_CHART_DIR

#Check vim
openstack vim list -c "ID" >> b.txt
vim=$(awk  'FNR==4{print val,$2}'  b.txt)

if [ -z "$vim" ]
then
      echo "VIM is not created"
      exit 1
fi

#update vim id in json file
cd /opt/stack/tacker/tacker/tests/xtesting/api-tests/SOL003/cnflcm/jsons
final_out='      "vimId": "'$vim\",
sed -i "s/$(grep vimId inst.json)/$final_out/" inst.json

#Update Helm Connection Information to VIM DB.
sudo mysql -uroot -pdevstack -h127.0.0.1 -Dtacker -e "update vims set extra=json_object(
         'helm_info', '{"masternode_ip": ["127.0.0.1"], "masternode_username": "stack", "masternode_password": "******"}')
         where id='$vim'";

#Execute script 'packageTest.sh' for package creation and uploading
cd ~/tacker/tacker/tests/xtesting/api-tests/SOL005/CNFPrecondition
./packageTest.sh  ../../SOL003/cnflcm/environment/variables.txt

#Start kubectl proxy.
kubectl proxy --port=8080 > /dev/null 2>&1 &

#Verify Cnflcm Create and Instantiate.
cd ~/tacker/tacker/tests/xtesting/
. xtesting-py3/bin/activate
sudo xtesting-py3/bin/run_tests -t cnf-instantiate

#Verify getting all pods and getting specific pod.
cd ~/tacker/tacker/tests/xtesting/
. xtesting-py3/bin/activate
sudo xtesting-py3/bin/run_tests -t cnf-deployments-validation

echo "---> xtesting-verify.sh ends"
