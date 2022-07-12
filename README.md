# Desafio Stn
Este desafio faz parte de um processo seletivo.
## :ninja: Objetivo do Desafio
- Criar um cluster de EKS em pelo menos 2 Availability Zones.
- Configurar uma instância de Prometheus rodando no EKS.
- Encontrar uma solução de monitoramento de rede do Kubernetes. Só queremos saber se todos os nodes estão conseguindo conversar entre si e qual é a latência.
- Configurar a solução de monitoramento de rede no EKS.
- Coletar as métricas usando o Prometheus ou qualquer outra ferramenta de métricas.

## Objetivo alcançado
- Criar um cluster de EKS em pelo menos 2 Availability Zones. :heavy_check_mark:
- Configurar uma instância de Prometheus rodando no EKS. :heavy_check_mark:
- Encontrar uma solução de monitoramento de rede do Kubernetes. Só queremos saber se todos os nodes estão conseguindo conversar entre si e qual é a latência. :x: 
  - (Não encontrei uma solução específica para isso).
- Configurar a solução de monitoramento de rede no EKS. :x:
  - (Dependia de uma solução de monitoramento de rede)
- Coletar as métricas usando o Prometheus ou qualquer outra ferramenta de métricas. :white_check_mark:
  - (Apesar dos pods node-exporters estarem prontos em ambos os nodes e não haver sinais de problema com eles, apenas um node consegue coletar as métricas)


## :hammer_and_wrench: Pré-requisitos
Antes de começar, você vai precisar ter instalado em sua máquina as seguintes ferramentas:
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) instalado e configurado.
- [Terraform](https://www.terraform.io/downloads).
- [kubectl](https://kubernetes.io/docs/tasks/tools/).
- [Helm](https://docs.helm.sh/docs/intro/quickstart/#install-helm) versão 3.0 ou posterior.
- Um bom editor para trabalhar com o código, como o [VSCode](https://code.visualstudio.com/).

## Sobre o Código
- ### eks-cluster.tf
Foi utilizado um módulo eks para criar o cluster e um módulo eks-metrics-server para instalar o metrics-server no cluster; também foram inseridos data sources para autenticação do k8s.
- ### helm-release.tf
Arquivo para subir o helm chart do Prometheus, o provedor helm utiliza o provedor kubernetes para autenticação via autoridade certificadora.
- ### provider.tf
Foi adicionado o provedor AWS e o provedor Kubernetes, que faz autenticação no servidor utilizando sua autoridade certificadora.
- ### sec-groups.tf
A entrada está comentada, caso seja necessário acessar os nodes diretamente, basta remover os comentários e alterar o cidr_blocks apontando para o IP desejado.
- ### variables.tf
Adicionei variáveis para nome do cluster e versão.
- ### vpc.tf
Cria uma VPC usando o módulo terraform vpc, utilizei apenas 2 azs e ativei o nat gateway, para permitir a saída das redes privadas para internet.
- ### iam.tf
ùltimo arquivo criado, ele cria duas service roles, uma para o EKS e outra para os NodeGroups.

## Comandos
- terraform init
- terraform plan
- terraform apply --auto-approve

#### Após o final da instalação é necessário criar ou atualizar um arquivo de configuração para o Cluster [kubeconfig](https://kubernetes.io/pt-br/docs/concepts/configuration/organize-cluster-access-kubeconfig/). Substitua *region-code* pela região AWS onde o cluster foi criado e *my-cluster* pelo nome do cluster.
<kbd>aws eks update-kubeconfig --region *region-code* --name *my-cluster*</kbd>
#### Para visualizar o Grafana, faça um port-forward e acesse http://localhost:3000/ utilize usuário: *admin* e senha: *prom-operator*
<kbd>kubectl port-forward -n monitoring deployment/prometheus-grafana 3000</kbd>

## Documentação utilizada
- https://registry.terraform.io/providers/hashicorp/aws/latest
- https://registry.terraform.io/providers/hashicorp/kubernetes/latest
- https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
- https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
- https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
- https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
- https://kubernetes.io/pt-br/docs/home/
- https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html

## Referências utilizadas
- https://blog.rocketseat.com.br/como-fazer-um-bom-readme/
- https://www.alura.com.br/curso-online-infraestrutura-codigo-terraform-kubernetes
- https://www.youtube.com/c/TechWorldwithNana
- https://www.youtube.com/c/MarcelDempers
- https://www.youtube.com/c/LinuxTips
- https://github.com/Josh-Tracy/Terraform-Helm-EKS-Jenkins
- https://github.com/AnaisUrlichs/terraform-helm-example