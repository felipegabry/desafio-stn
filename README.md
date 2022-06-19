# desafio-stn

-   Atualizei meu código, removendo por hora o variables.tf, renomeando o main.tf para provider.tf, melhorando o EKS.tf, VPC.tf e sec-groups.tf.

-   Utilizei 3 abordagens diferentes para a criação do cluster utilizando o Terraform, porém, mantive a metodologia KISS e apenas alterei algumas coisas, para que meu código não ficasse muito grande.

-   Criei um usuário IAM chamado terraform, e um aws profile para este usuário. as informações foram guardadas em 2 arquivos (.aws/config e .aws/credentials).

-   O próximo passo é voltar na documentação oficial do EKS na AWS para checar se é necessária alguma instalação no cluster antes de seguir.

-   Após isso irei seguir com a instalação e configuração do Prometheus no cluster.
