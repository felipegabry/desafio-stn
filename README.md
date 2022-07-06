# desafio-stn

-   Atualizei meu código, adicionando novamente o variables.tf.

-   Renomeei o VPC.tf para vpc.tf e removi uma AZ, deixando apenas duas, também habilitei o dns_hostnames e o single_nat_gateway.

-   Renomeei o EKS.tf para eks-cluster.tf e alterei os tipos de instância, adicionei os add-ons no módulo eks, adicionei Data Sources para autenticação no k8s e adicionei um módulo para instalar o metrics-server.

-   Criei o helm-releases.tf, ele utiliza o Data Source no eks-cluster.tf para se conectar com meu cluster e fazer as instalações, tem um recurso helm_release para o calico e um para o prometheus (que por default também instala o chart do grafana).
