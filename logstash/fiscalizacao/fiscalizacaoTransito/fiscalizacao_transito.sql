SELECT it.id                                                               AS id,
       t.data_hora_transito                                                AS emissao,
       UPPER(t.placa_veiculo)                                              AS placa,
       CASE WHEN t.bo_exportacao THEN 'Sim' else 'Não' END                 AS exportacao,

       CASE
           WHEN t.id_transito_tablet is null THEN 'Web'
           ELSE 'Mobile'
           END                                                               AS sistema,

       (SELECT case when COUNT(tf.id_termofiscalizacao) != 0 then 'Sim' else 'Não' end
        FROM fisc.termo_fiscalizacao AS tf
        WHERE tf.id_transito = t.id
          AND tf.tem_auto = TRUE)                                          AS autuado,

       (SELECT COUNT(tf.id_termofiscalizacao)
        FROM fisc.termo_fiscalizacao AS tf
        WHERE tf.id_transito = t.id
          AND tf.ativo = TRUE)                                             AS termo_fiscalizacao_quantidade,

       case when t.ativo then 'Não' else 'Sim' end                         AS cancelada,

       t.id                                                                AS transito_id,

       p.ds_nome                                                           AS produto_tipo,
       um.no_unidademedida                                                 AS produto_medida,
       it.qtde_produto                                                     AS produto_quantidade,
       p.ds_classificacaoproduto                                           AS produto_classificacao,

       l.nome                                                              AS fiscalizacao_localizacao_nome,
       COALESCE(REGEXP_REPLACE(t.vl_latitude, '[^0-9.]+', ' ', 'g'), '0')  AS fiscalizacao_localizacao_gps_latitude,
       COALESCE(REGEXP_REPLACE(t.vl_longitude, '[^0-9.]+', ' ', 'g'), '0') AS fiscalizacao_localizacao_gps_longitude,
       mf.loc_no                                                           AS fiscalizacao_municipio_nome,
       COALESCE(mf.lat, 0)                                                 AS fiscalizacao_municipio_gps_latitude,
       COALESCE(mf.lon, 0)                                                 AS fiscalizacao_municipio_gps_longitude,

       pf.id                                                               AS fiscal_id,
       pf.nome                                                             AS fiscal_nome,
       dof.numero                                                          AS fiscal_cpf,

       CASE
           WHEN t.tp_posto = 'fixo' THEN 'Posto Fixo'
           WHEN t.tp_posto = 'movel' THEN 'Posto Movel'
           END                                                               AS posto,

       po.nome                                                             AS origem_nome,
       dor.numero                                                          AS origem_documento,
       mo.loc_no                                                           AS origem_municipio_nome,
       mo.ufe_sg                                                           AS origem_municipio_uf,
       COALESCE(mo.lat, 0)                                                 AS origem_municipio_gps_latitude,
       COALESCE(mo.lon, 0)                                                 AS origem_municipio_gps_longitude,

       pd.nome                                                             AS destino_nome,
       dd.numero                                                           AS destino_documento,
       md.loc_no                                                           AS destino_municipio_nome,
       md.ufe_sg                                                           AS destino_municipio_uf,
       COALESCE(md.lat, 0)                                                 AS destino_municipio_gps_latitude,
       COALESCE(md.lon, 0)                                                 AS destino_municipio_gps_longitude,

       dt.numero_documento_transito                                        AS documento_numero,
       tdt.sigla                                                           AS documento_sigla,
       tdt.nome                                                            AS documento_nome
FROM mt.transito t
         LEFT JOIN rh.lotacao AS l ON t.id_lotacaofiscalizacao = l.id
         LEFT JOIN mt.item_transito AS it ON t.id = it.fk_transito_id
         LEFT JOIN mt.documento_transito AS dt ON it.fk_documento_transito_id = dt.id
         LEFT JOIN mt.tipo_documento_transito AS tdt ON dt.fk_tipo_documento_transito_id = tdt.id
         INNER JOIN rh.pessoa AS pf ON t.fk_funcionario_fiscal = pf.id
         LEFT JOIN rh.documento AS dof ON pf.id = dof.id_pessoa AND dof.id_documento_tipo = 1
         LEFT JOIN dne.log_localidade AS mf ON t.id_municipio_fiscalizacao = mf.loc_nu
         LEFT JOIN mt.estabelecimento_transito AS eo ON eo.id = t.fk_estabelecimento_origem
         LEFT JOIN mt.estabelecimento_transito AS ed ON ed.id = t.fk_estabelecimento_destino
         LEFT JOIN dne.log_localidade AS mo ON eo.fk_municipio = mo.loc_nu
         LEFT JOIN dne.log_localidade AS md ON ed.fk_municipio = md.loc_nu
         LEFT JOIN rh.pessoa AS po ON eo.fk_proprietario = po.id
         LEFT JOIN rh.pessoa AS pd ON ed.fk_proprietario = pd.id
         LEFT JOIN rh.documento AS dor ON po.id = dor.id_pessoa AND dor.id_documento_tipo IN (1, 2)
         LEFT JOIN rh.documento AS dd ON pd.id = dd.id_pessoa AND dd.id_documento_tipo IN (1, 2)
         LEFT JOIN produtos.subproduto AS s ON it.id_subproduto = s.id_subproduto
         LEFT JOIN produtos.produto AS p ON it.fk_produto_id = p.id_produto
         LEFT JOIN produtos.unidademedida AS um ON s.id_unidademedida = um.id_unidademedida
WHERE t.data_hora_cadastro_transito::date >= current_date - interval '1 month'
ORDER BY it.id
