#Projeto Elasticsearch

## Kibana

- [ ] Instalação do recurso de Role-based access control gratuito https://search-guard.com/product/
- [ ] Verificar recurso para relatorio https://www.skedler.com/
- [ ] Criar Dashboard para Vacinação
- [ ] Criar Dashborar para Movimentação

## Sidago Import

- [x] Alterar campo cancelada para Cancelado (Sim, Não)
- [x] Criar campo Origem Tipo
- [x] Criar campo Destino Tipo
- [x] Criar campo Total Estraficacao 

## Banco Sidago

- [ ] Verificar a possibilidade de criar campos de latitude e longitude na tabela de estabelecimento no formato decimal
- [x] Criar campo Data alteração e dar update na tabela de GTA


    ts_alteracao timestamp default now() not null,

## Sistema Sidago

- [ ] Ao criar ou cancelar uma GTA chamar o WebService a definir.
- [ ] Integrar Sigado ao Elasticsearch
- [x] Quando cancelar uma GTA alterar a data ts_alteracao para now()
- [ ] Verificar relatorio [Relatório de Vacinação VA1](http://sidago.agrodefesa.go.gov.br/defesa-sanitaria-animal/relatorio-vacinacao-va1/relatorio?parametros=true&modelo_relatorio=DT&id_campanha_vacina_tipo=1&id_campanha_vacina=46&bo_travamento=&tp_relatorio=GO&id_lotacao=&id_municipio=&bo_area_risco=&&erl=0664ec93c1f5251d536aa51bb993819f&nam=9568690). 
Criar um indice com as informações deste relatorio.
  
## Responsaveis

- Levantar e apresentar requisitos com Luiz Fernando (GTA)
