SELECT chtf.id_checklistrespostatf                                              AS id,
       case when ch.bo_ativo then 'Não' else 'Sim' end                          AS cancelada,
       pro.ds_programa                                                          AS programa,
       tf.ts_alteracao                                                          AS ts_alteracao,
       CASE
           WHEN ch.tp_identificacao = 'bo_propriedade' THEN 'Propriedade'
           WHEN ch.tp_identificacao = 'bo_empresa' THEN 'Empresa'
           WHEN ch.tp_identificacao = 'bo_industria' THEN 'Industria'
           WHEN ch.tp_identificacao = 'bo_evento' THEN 'Evento'
           ELSE 'Não identificado'
           END                                                                  AS identificacao,
       ch.id_checklist                                                          AS check_list_id,
       ch.ds_descritivo                                                         AS check_list_descricao,
       cp.ds_pergunta                                                           AS pergunta,
       TRIM(UPPER(cr.ds_resposta))                                              AS resposta,
       cr.nu_pontuacao                                                          AS pontuacao,
       COALESCE(ie.nu_inscricaoestadual, CAST(ie.id_inscricaoestadual AS TEXT)) AS fiscalizado_ie,
       UPPER(COALESCE(ie.no_fantasia, tf.ds_nomerazao))                         AS fiscalizado_nome,
       mf_lr.nome                                                               AS fiscalizado_regional_nome,
       mf.loc_no                                                                AS fiscalizado_municipio_nome,
       mf.ufe_sg                                                                AS fiscalizado_municipio_uf,
       COALESCE(mf.lat, 0)                                                      AS fiscalizado_municipio_localizacao_latitude,
       COALESCE(mf.lon, 0)                                                      AS fiscalizado_municipio_localizacao_longitude,

       UPPER(pse.nome)                                                          AS emissor_nome,
       dse.numero                                                               AS emissor_documento,

       tf.id_termofiscalizacao                                                  AS termo_fiscalizacao_id,
       tf.id_entidade                                                           AS termo_fiscalizacao_entidade_id,
       tf.ds_rginscricaoestadual                                                AS termo_fiscalizacao_entidade_documento,
       tf.dt_criacaotermo                                                       AS termo_fiscalizacao_emissao,
       case when tf.ativo then 'Não' else 'Sim' end                             AS termo_fiscalizacao_cancelada
FROM fisc.checklist AS ch
         INNER JOIN fisc.programa_fiscalizacao AS pro ON ch.id_programafiscalizacao = pro.id_programafiscalizacao
         INNER JOIN fisc.checklist_pergunta AS cp ON cp.id_checklist = ch.id_checklist
         INNER JOIN fisc.checklist_resposta AS cr ON cr.id_checklistpergunta = cp.id_checklistpergunta
         INNER JOIN fisc.checklistresposta_tf AS chtf ON chtf.id_checklistresposta = cr.id_checklistresposta
         INNER JOIN fisc.termo_fiscalizacao AS tf ON tf.id_termofiscalizacao = chtf.id_termofiscalizacao
         LEFT JOIN agrocomum.inscricaoestadual as ie ON tf.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN dne.log_localidade AS mf ON mf.loc_nu = tf.id_municipio_fiscalizado
         LEFT JOIN rh.lotacao AS mf_l
                   ON mf.loc_nu = mf_l.id_localidade AND mf_l.id_lotacaotipo = 3 AND mf_l.bo_ativo = true AND
                      mf_l.bo_organograma = true
         LEFT JOIN rh.lotacao AS mf_lr
                   ON mf_lr.id = mf_l.id_lotacao_pai AND mf_lr.id_lotacaotipo = 2 AND mf_lr.bo_ativo = true AND
                      mf_lr.bo_organograma = true
         LEFT JOIN rh.pessoa AS pse ON pse.id = tf.id_criadortermo
         LEFT JOIN rh.documento AS dse ON dse.id_pessoa = pse.id and dse.id_documento_tipo in (1, 2)
WHERE ch.id_checklist in (12, 18)
  AND tf.ts_alteracao > :sql_last_value
ORDER BY chtf.id_checklistrespostatf
