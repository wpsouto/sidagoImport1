SELECT tro.id_termoobjetivo                            AS id,
       tf.id_termofiscalizacao                         AS termofiscalizacao_id,
       CAST(tf.nu_termo AS integer)                    AS numero,
       tf.nu_serie                                     AS serie,
       tf.dt_criacaotermo                              AS emissao,
       tf.ts_alteracao                                 AS ts_alteracao,
       pr.ds_programa                                  AS programa,
       ob.ds_objetivo                                  AS objetivo,
       su.ds_subobjetivofiscalizacao                   AS subObjetivo,
       pd.ds_nome                                      AS produto,
       epd.ds_especificacaoproduto                     AS subProduto,
       tro.nu_quantidade                               AS quantidade,
       case when tf.tem_auto then 'Sim' else 'Não' end AS autuado,
       case when tf.ativo then 'Não' else 'Sim' end    AS cancelada,

       CASE
           WHEN tf.bo_tablet THEN 'Mobile'
           ELSE
               CASE
                   WHEN tf.tp_documento = 'informatizado' THEN 'Informatizado'
                   WHEN tf.tp_documento = 'branco' THEN 'Gerado em Branco'
                   ELSE 'Bloco de Gráfica'
                   END
           END                                           AS tipo,

       CASE
           WHEN tf.tp_caracterizacao = 'AN' THEN 'Animal'
           WHEN tf.tp_caracterizacao = 'VE' THEN 'Vegetal'
           ELSE 'Não classificado'
           END                                           AS caracterizacao,

       CASE
           WHEN tf.bo_propriedade THEN 'Propriedade'
           WHEN tf.bo_empresa THEN 'Estabelecimento Comercial'
           WHEN tf.bo_industria THEN 'Estabelecimento Industrial'
           WHEN tf.bo_transito THEN 'Trânsito'
           WHEN tf.bo_evento THEN 'Evento Agropecuário'
           ELSE
               CASE
                   WHEN tf.no_entidade = 'pessoa' THEN 'Pessoa Física'
                   WHEN tf.no_entidade = 'propriedade' THEN 'Propriedade'
                   WHEN tf.no_entidade = 'outro' THEN 'Outros não indentificado'
                   ELSE 'Não classificado'
                   END
           END                                           AS identificacao,

       tf.ds_rginscricaoestadual                       AS fiscalizado_ie,
       pfi.nome                                        AS fiscalizado_nome,
       dfi.numero                                      AS fiscalizado_documento,
       mf_lr.nome                                      AS fiscalizado_regional_nome,
       mf.loc_no                                       AS fiscalizado_municipio_nome,
       mf.ufe_sg                                       AS fiscalizado_municipio_uf,
       COALESCE(mf.lat, 0)                             AS fiscalizado_municipio_localizacao_latitude,
       COALESCE(mf.lon, 0)                             AS fiscalizado_municipio_localizacao_longitude,

       pse.nome                                        AS emissor_nome,
       dse.numero                                      AS emissor_documento

FROM fisc.termo_fiscalizacao AS tf
         INNER JOIN fisc.termoobjetivo_fiscalizacao AS tro ON tf.id_termofiscalizacao = tro.id_termofiscalizacao
         INNER JOIN fisc.programa_fiscalizacao AS pr ON tro.id_programafiscalizacao = pr.id_programafiscalizacao
         INNER JOIN fisc.objetivo_fiscalizacao AS ob ON tro.id_objetivofiscalizacao = ob.id_objetivofiscalizacao
         LEFT JOIN fisc.subobjetivo_fiscalizacao AS su ON tro.id_subobjetivofiscalizacao = su.id_subobjetivofiscalizacao
         LEFT JOIN produtos.produto AS pd ON tro.id_produto = pd.id_produto
         LEFT JOIN produtos.subproduto AS spd ON tro.id_subproduto = spd.id_subproduto
         LEFT JOIN produtos.especificacao_produto AS epd ON epd.id_especificacaoproduto = spd.id_especificacaoproduto
         LEFT JOIN rh.pessoa AS pfi ON pfi.id = tf.id_entidade
         LEFT JOIN rh.documento AS dfi ON dfi.id_pessoa = pfi.id and dfi.id_documento_tipo in (1, 2)
         LEFT JOIN rh.pessoa AS pse ON pse.id = tf.id_criadortermo
         LEFT JOIN rh.documento AS dse ON dse.id_pessoa = pse.id and dse.id_documento_tipo in (1, 2)
         LEFT JOIN dne.log_localidade AS mf ON mf.loc_nu = tf.id_municipio_fiscalizado
         LEFT JOIN rh.lotacao AS mf_l
                   ON mf.loc_nu = mf_l.id_localidade AND mf_l.id_lotacaotipo = 3 AND mf_l.bo_ativo = true AND
                      mf_l.bo_organograma = true
         LEFT JOIN rh.lotacao AS mf_lr
                   ON mf_lr.id = mf_l.id_lotacao_pai AND mf_lr.id_lotacaotipo = 2 AND mf_lr.bo_ativo = true AND
                      mf_lr.bo_organograma = true
WHERE tf.bo_termoautojuridico = false
  AND tf.ts_alteracao > :sql_last_value

ORDER BY tro.id_termoobjetivo
