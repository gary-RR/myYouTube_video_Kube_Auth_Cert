#Log on to 
export MASTER_IP_ADDRESS="192.168.0.38"

#View the current config (under ~/.kube)
kubectl config view
#To view the raw file (unredacted):
kubectl config view --raw

#Beging constructing a config file for our new user "john.doe".
#Start by creating the "cluster" section of the config file
kubectl config set-cluster cluster1 \
  --server=https://$MASTER_IP_ADDRESS:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true \
  --kubeconfig=john.doe.conf


#Check if the file created
ls john.doe.conf

#Verify the "cluster" section of the config file created
kubectl config view --kubeconfig=john.doe.conf


#Now lets add our "user" section of the config file
kubectl config set-credentials john.doe \
  --client-key=john.doe.key \
  --client-certificate=john.doe.crt \
  --embed-certs=true \
  --kubeconfig=john.doe.conf

#Verify
kubectl config view --kubeconfig=john.doe.conf


#Create the context section
kubectl config set-context john.doe@cluster1  \
  --cluster=cluster1\
  --user=john.doe \
  --kubeconfig=john.doe.conf


#View the completed config for our user "john.do"
kubectl config view --kubeconfig=john.doe.conf


#Set the default context to "john.doe@cluster1"
kubectl config use-context john.doe@cluster1 --kubeconfig=john.doe.conf

#Use "john.doe"'s config file to get "cluster-info" form the our cluster
kubectl get pod --kubeconfig=john.doe.conf #-v 6

#Rename it to "conf" 
#mv john.doe.conf conf