#Explore the authentication and authorization default settings:
# --authorization-mode=
# --client-ca-file=
# --enable-bootstrap-token-auth=
# --oidc-issuer-url=
# --token-auth-file=
sudo nano  /etc/kubernetes/manifests/kube-apiserver.yaml

#Service account
cat 
kubectl apply -f service-account.yaml

#Examine the service account
kubectl get serviceaccount myservice-svc-acct -o yaml
SECRETNAME=$(kubectl get serviceaccount myservice-svc-acct  -o jsonpath='{.secrets[0].name }')
echo $SECRETNAME
#View the auth token
kubectl describe secret $SECRETNAME

# #Check if "myservice-svc-acct" has "list pod" access
# kubectl auth can-i list pods --as=system:serviceaccount:default:myservice-svc-acct

kubectl apply -f hello-world-deployment.yaml

#Get the POD's name
POD=$(kubectl get pods |  grep hello-world | awk '{ print $1}' )
echo $POD

#Verify that the service account is associated with the POD
kubectl get pod $POD -o yaml

#Exec it it
kubectl exec -it $POD -- sh
    #View how service accounts' info is mounted
    ls /var/run/secrets/kubernetes.io/serviceaccount/

kubectl delete deployment hello-world
kubectl delete serviceaccount myservice-svc-acct