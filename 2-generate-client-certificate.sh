#Generte a private key
openssl genrsa -out john.doe.key 2048

#Generate a CSR
#/CN (Common Name) is the username, and /O (Organization) is the group(s) the user belongs to
openssl req -new -key john.doe.key -out john.doe.csr \
 -subj "/CN=john.doe/O=marketing-dev/O=hr-dev"

#The certificate request we'll use in the CertificateSigningRequest
cat john.doe.csr


#Encode CSR (base64)
#And also have the header and trailer pulled out.
cat john.doe.csr | base64 | tr -d "\n" > john.doe.base64.csr
cat john.doe.base64.csr

#Submit the CertificateSigningRequest to the API Server
#Key elements, name, request, signerName and usages (must be client auth)
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john.doe
spec:
  groups:
  - system:authenticated  
  request: $(cat john.doe.base64.csr)
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF


#View the CSRs, it will show as "pending" status
kubectl get certificatesigningrequests


#Approve the CSR (Note, you'll have one hour to apprvoe it, otherwise it will be garbage collected!)
kubectl certificate approve john.doe


#View the cert requets and its status
kubectl get certificatesigningrequests john.doe 


#Retrieve the certificate from the CSR object, it's base64 encoded
kubectl get certificatesigningrequests john.doe \
  -o jsonpath='{ .status.certificate }'  | base64 --decode


#We'll save save this to a file:
kubectl get certificatesigningrequests john.doe \
  -o jsonpath='{ .status.certificate }'  | base64 --decode > john.doe.crt 


#View the cert
cat john.doe.crt

#Read the cert in human readable format and review CA, and subjet (CN and Organizaions(groups))
openssl x509 -in john.doe.crt -text -noout | head -n 15

#Clean up
rm jo*.*
