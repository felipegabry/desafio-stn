# desafio-stn

 ##### IaaC para subir um Cluster EKS #####

- Utilizei um curso da Alura como base para iniciar o projeto.
(https://cursos.alura.com.br/course/infraestrutura-codigo-terraform-kubernetes)

- Fiz algumas edições nos módulos que peguei, e por enquanto o módulo de variáveis está vazio, 
o módulo main só tem o provider e por enquanto os módulos EKS, sec-groups e VPC estão fechados.

- Com essa infraestrutura eu já consigo subir o cluster EKS e 3 instâncias, assim como a VPC e os grupos de segurança para o cluster.
Também foi criado um endpoint de acesso privado para que eu me comunique com o cluster.

- O próximo passo será criar um módulo de configuração para o cluster.
