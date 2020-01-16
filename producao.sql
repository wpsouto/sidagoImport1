SELECT
    pid
    ,application_name
    ,client_hostname
    ,backend_start
    ,query_start,
    TO_CHAR(now()- query_start, 'MI:SS') as tempo
    ,query
FROM pg_stat_activity
WHERE state = 'active'
order by tempo desc;

select count(distinct a.id_acesso)
from auditoria.auditoria a
WHERE a.ts_realizado >= (now() - interval '20' minute)
  and no_modulo <> 'Webservice';

select count(distinct c.id_pessoa) as usuarios_conectados
from miner.requisicao c
WHERE c.ts_pedido >= (now() - interval '20' minute)

select count(c.id_pessoa) as requisicao,
       c.id_pessoa
from miner.requisicao c
WHERE c.ts_pedido >= (now() - interval '20' minute)
group by c.id_pessoa
order by count(c.id_pessoa) desc

select *
from miner.requisicao c
WHERE c.ts_pedido >= (now() - interval '20' minute)
  and id_pessoa = 474

    show timezone;

SET TIMEZONE TO 'America/Sao_Paulo';

select * from pg_timezone_names;

show statement_timeout;

SELECT LOCALTIMESTAMP, CURRENT_TIMESTAMP, now();

SELECT pg_terminate_backend(56208);


SELECT last_value FROM dsa.estratificacao_id_seq;
SELECT max(id) from dsa.estratificacao;
SELECT setval('serial_id_seq',  valor);

select count(id_gta) from gta.gta where ts_emissao >= '2019-04-04 00:00:00' and ts_emissao <= '2019-04-04 23:59:59' and bo_ativo = false
select count(id_gta) from gta.gta where ts_emissao >= '2019-04-04 00:00:00' and ts_emissao <= '2019-04-04 23:59:59' and bo_ativo = true
select count(id_gta) from gta.gta where ts_emissao >= '2019-04-04 00:00:00' and ts_emissao <= '2019-04-04 23:59:59'

select * from gta.gta where ts_emissao >= '2019-04-03 00:00:00' and ts_emissao <= '2019-04-03 23:59:59' order by  ts_alteracao desc


create index classificacao_tp_identificacao_idx
on agrocomum.classificacao (tp_identificacao);

create index ix_fisc_termo_fiscalizacao_dt_criacaotermo_mes on fisc.termo_fiscalizacao (date_trunc('month', dt_criacaotermo::timestamp ));

create index ix_fisc_termo_fiscalizacao_ativo
on fisc.termo_fiscalizacao (ativo);

SELECT LOCALTIMESTAMP, CURRENT_TIMESTAMP, now(), CURRENT_DATE;

vacuum analyze dsa.exploracao_propriedade;

SELECT CAST(current_setting('server_version_num') AS integer) AS v

create index miner_requisicao_ts_pedido_idx
on miner.requisicao (ts_pedido);

create table public.bkp_checklistresposta_tf AS table fisc.checklistresposta_tf

select count(tf.id_termofiscalizacao)
from agrocomum.endereco as e
         inner join agrocomum.inscricaoestadual_endereco as iee on iee.id_endereco = e.id_endereco
         inner join agrocomum.inscricaoestadual as ie on ie.id_inscricaoestadual = iee.id_inscricaoestadual
         inner join fisc.termo_fiscalizacao as tf on tf.id_inscricaoestadual = ie.id_inscricaoestadual
WHERE  tf.id_municipio_fiscalizado is null

update fisc.termo_fiscalizacao
set id_municipio_fiscalizado = e.id_localidade,
    ts_alteracao             = current_timestamp
    from agrocomum.endereco as e
    inner join agrocomum.inscricaoestadual_endereco as iee on iee.id_endereco = e.id_endereco
                                                              inner join agrocomum.inscricaoestadual as ie on ie.id_inscricaoestadual = iee.id_inscricaoestadual
where fisc.termo_fiscalizacao.id_inscricaoestadual = ie.id_inscricaoestadual
    and fisc.termo_fiscalizacao.id_municipio_fiscalizado is null

select count(distinct g.id_certificado)
from gtv.certificado c
         inner join gtv.gtv g on c.id_certificado = g.id_certificado
where c.bo_ativo is true
  --  and date_part('year', g.dt_emissao) = 2019
  --    and date_trunc('DAY', g.dt_emissao) = date_trunc('MONTH', NOW() - INTERVAL '1 MONTH')
  and date_trunc('DAY', g.dt_emissao) between '01/10/2019' and '15/10/2019'
  and g.tp_transitotipo = '2'

SELECT date_trunc('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH';

SELECT date_trunc('DAY', g.dt_emissao), g.dt_emissao , g.dt_emissao - INTERVAL '1 DAY'
FROM gtv.gtv g
order by g.dt_emissao desc
