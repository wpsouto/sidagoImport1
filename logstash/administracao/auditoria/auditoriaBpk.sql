select a.id_acesso   AS acesso_id,
       a.ts_entrada  AS acesso_entrada,
       a.nu_ipv4     AS acesso_ip,
       a.id_pessoa   AS acesso_pessoa_id,
       pe.nome       AS acesso_pessoa_nome,
       lt.id         AS acesso_pessoa_lotacao_id,
       lt.nome       AS acesso_pessoa_lotacao_nome,
       a.ds_brownser AS acesso_brownser,
       aud.*

from auditoria.acesso a
         INNER JOIN rh.pessoa AS pe ON a.id_pessoa = pe.id
         INNER JOIN rh.lotacao AS lt ON a.id_lotacao = lt.id
         INNER JOIN auditoria.auditoria AS aud ON a.id_acesso = aud.id_acesso
--         join auditoria.operacao o on o.id_auditoria = aud.id_auditoria
--         join auditoria.valor v on v.id_operacao = o.id_operacao
--         join auditoria.operacao_tipo ot on ot.id_operacaotipo = o.id_operacaotipo
where a.id_acesso = 10900003
order by a.ts_entrada asc
