SELECT ch.id           AS                                                      id,
       ch.dt_chamado   AS                                                      abertura,
       ch.dt_adocao    AS                                                      adocao,
       chh.atualizacao AS                                                      atualizacao,
       ch.ds_problema  AS                                                      solicitacao,
       ch.nu_jira      AS                                                      jira_id,
       case when trim(coalesce(ch.nu_jira, '')) = '' then 'Não' else 'Sim' end jira_tarefa,

       cc.id           AS                                                      classificacao_id,
       cc.nome         AS                                                      classificacao_nome,

       tc.id           AS                                                      tecnico_id,
       tc.nome         AS                                                      tecnico_nome,
       CASE
           WHEN ch.id_situacao = 1 THEN 'Sem adoção'
           WHEN ch.id_situacao = 2 THEN 'Adotado pelo técnico'
           WHEN ch.id_situacao = 3 THEN 'Resolvido pelo técnico'
           WHEN ch.id_situacao = 4 THEN 'Desistência do usuário'
           WHEN ch.id_situacao = 5 THEN 'Improcedente'
           WHEN ch.id_situacao = 9 THEN 'Atualizado pelo solicitante'
           WHEN ch.id_situacao = 10 THEN 'Repassado para o solicitante'
           WHEN ch.id_situacao = 12 THEN 'Não se aplica à T.I.'
           WHEN ch.id_situacao = 20 THEN 'Manutenção: encaminhado para assistência'
           WHEN ch.id_situacao = 21 THEN 'Manutenção: aguardando garantia'
           WHEN ch.id_situacao = 22 THEN 'Manutenção: equipamento sucateado'
           WHEN ch.id_situacao = 23 THEN 'Manutenção: equipamento devolvido'
           WHEN ch.id_situacao = 24 THEN 'Aguardando Terceiros'
           WHEN ch.id_situacao = 26 THEN 'Finalizar: Cancelamento'
           WHEN ch.id_situacao = 28 THEN 'Em Análise de Informações'
           ELSE 'Não Informado'
           END         AS                                                      situacao,

       CASE
           WHEN ch.id_tipo_contato = 1 THEN 'Email'
           WHEN ch.id_tipo_contato = 2 THEN 'Telefone'
           WHEN ch.id_tipo_contato = 3 THEN 'Sistema'
           ELSE 'Não Informado'
           END         AS                                                      tipo_contato,

       CASE
           WHEN cc.id_tipo = 1 THEN 'Equipamentos - Suporte'
           WHEN cc.id_tipo = 2 THEN 'Sistemas Internos'
           WHEN cc.id_tipo = 3 THEN 'Outros Programas'
           WHEN cc.id_tipo = 4 THEN 'Redes'
           WHEN cc.id_tipo = 5 THEN 'Gerência T.I.'
           WHEN cc.id_tipo = 6 THEN 'Equipamentos - Manutenção'
           ELSE 'Não Informado'
           END         AS                                                      tipo_suporte,

       pe.id           AS                                                      solicitante_id,
       pe.nome         AS                                                      solicitante_nome,
       lt.id           AS                                                      solicitante_lotacao_id,
       lt.nome         AS                                                      solicitante_lotacao_nome
FROM chamado.chamado_abrir ch
         INNER JOIN rh.pessoa AS pe ON ch.id_pessoa = pe.id
         INNER JOIN rh.lotacao AS lt ON ch.id_lotacao = lt.id
         LEFT JOIN rh.pessoa AS tc ON ch.id_pessoa_tec = tc.id
         INNER JOIN chamado.chamado_classificacao AS cc ON ch.id_classificacao = cc.id
         INNER JOIN (SELECT id_chamado       AS id_chamado,
                            MAX(dt_registro) AS atualizacao
                     FROM chamado.chamado_historico chh
                     GROUP BY id_chamado) AS chh ON ch.id = chh.id_chamado
WHERE chh.atualizacao > DATE_TRUNC('minute', TIMESTAMP :sql_last_value - interval '3 hour')
ORDER BY ch.id desc
