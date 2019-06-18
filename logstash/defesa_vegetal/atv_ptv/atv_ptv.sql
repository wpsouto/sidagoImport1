SELECT pg.id_produto_gtv                               AS id,
       case when ce.bo_ativo then 'Não' else 'Sim' end AS cancelada,
       gt.dt_emissao                                   AS emissao,
       COALESCE(gt.vl_total, 0)                        AS valor,
       ce.ts_alteracao                                 AS ts_alteracao,

       CASE
           WHEN ce.id_situacao = '1' THEN 'Aguardando Homologação'
           WHEN ce.id_situacao = '2' THEN 'Homologado'
           WHEN ce.id_situacao = '3' THEN 'Indeferido'
           ELSE 'Não Informado'
           END                                         AS situação,

       CASE
           WHEN gt.tp_transitotipo = '1' THEN 'ATV'
           WHEN gt.tp_transitotipo = '2' THEN 'PTV'
           ELSE 'PTV Exportação'
           END                                         AS transito_tipo,

       gt.id_certificado                               AS certificado_id,
       gt.nu_gtv                                       AS certificado_numero,
       CASE
           WHEN gt.tp_certificado = '1' THEN 'CFO'
           WHEN gt.tp_certificado = '2' THEN 'CFOC'
           WHEN gt.tp_certificado = '3' THEN 'GTV'
           WHEN gt.tp_certificado = '4' THEN 'Ficha de Inspeção'
           WHEN gt.tp_certificado = '5' THEN 'Unidade de Produção'
           WHEN gt.tp_certificado = '6' THEN 'Lote'
           WHEN gt.tp_certificado = '7' THEN 'GTV Outro Estado'
           WHEN gt.tp_certificado = '8' THEN 'ATVC'
           WHEN gt.tp_certificado = '9' THEN 'Nota Fiscal'
           WHEN gt.tp_certificado = '10' THEN 'Autorização Mudas'
           ELSE 'Não Informado'
           END                                         AS certificado_tipo,

       UPPER(ph.nome)                                  AS homologador_nome,
       dh.numero                                       AS homologador_documento,

       pe.nome                                         AS emissor_nome,
       de.numero                                       AS emissor_documento,
       lote.id                                         AS emissor_lotacao_id,
       lote.nome                                       AS emissor_lotacao_nome,
       reg.id                                          AS emissor_lotacao_regional_id,
       reg.nome                                        AS emissor_lotacao_regional_nome,

       por.id                                          AS origem_pessoa_id,
       dor.numero                                      AS origem_pessoa_documento,
       UPPER(por.nome)                                 AS origem_pessoa_nome,
       llor.loc_no                                     AS origem_municipio_nome,
       llor.ufe_sg                                     AS origem_municipio_uf,
       COALESCE(llor.lat, 0)                           AS origem_municipio_gps_latitude,
       COALESCE(llor.lon, 0)                           AS origem_municipio_gps_longitude,

       pdes.id                                         AS destino_pessoa_id,
       ddes.numero                                     AS destino_pessoa_documento,
       UPPER(pdes.nome)                                AS destino_pessoa_nome,
       lldes.loc_no                                    AS destino_municipio_nome,
       lldes.ufe_sg                                    AS destino_municipio_uf,
       COALESCE(lldes.lat, 0)                          AS destino_municipio_gps_latitude,
       COALESCE(lldes.lon, 0)                          AS destino_municipio_gps_longitude,

       epr.id_especificacaoproduto                     AS especificacao_id,
       epr.ds_especificacaoproduto                     AS especificacao_nome,

       ppr.id_produto                                  AS produto_id,
       ppr.ds_nome                                     AS produto_nome,

       cult.id_cultivar                                AS cultivar_id,
       cult.no_cultivar                                AS cultivar_nome,
       cult.ds_nome_cientifico                         AS cultivar_nome_cientifico,
       upr.no_unidademedida                            AS cultivar_unidade,
       prod.qt_produto                                 AS cultivar_quantidade,
       COALESCE(gt.vl_total, 0) / produtos.registros   AS cultivar_valor

FROM gtv.gtv AS gt
         INNER JOIN gtv.certificado AS ce ON gt.id_certificado = ce.id_certificado
         INNER JOIN gtv.produto_gtv AS pg ON pg.id_certificado = gt.id_certificado
         INNER JOIN gtv.produto AS prod ON pg.id_produto = prod.id_produto
         INNER JOIN gtv.cultivar AS cult ON cult.id_cultivar = prod.id_cultivar

         INNER JOIN produtos.subproduto spr ON spr.id_subproduto = prod.id_subproduto
         INNER JOIN produtos.produto ppr ON ppr.id_produto = spr.id_produto
         INNER JOIN produtos.especificacao_produto epr ON epr.id_especificacaoproduto = spr.id_especificacaoproduto
         INNER JOIN produtos.unidademedida upr ON upr.id_unidademedida = spr.id_unidademedida

         INNER JOIN rh.pessoa AS por ON por.id = gt.id_pessoa_origem
         INNER JOIN rh.documento AS dor ON por.id = dor.id_pessoa AND dor.id_documento_tipo IN (1, 2)
         LEFT JOIN gtv.endereco_interessado AS eor ON gt.id_certificado = eor.id_certificado
         LEFT JOIN dne.log_localidade AS llor ON llor.loc_nu = eor.id_localidade

         INNER JOIN rh.pessoa AS pdes ON pdes.id = gt.id_pessoa_destino
         INNER JOIN rh.documento AS ddes ON pdes.id = ddes.id_pessoa AND ddes.id_documento_tipo IN (1, 2)
         LEFT JOIN gtv.endereco_destinatario AS edes ON gt.id_certificado = edes.id_certificado
         LEFT JOIN dne.log_localidade AS lldes ON lldes.loc_nu = edes.id_localidade

         INNER JOIN (SELECT max(id_certificadohistorico) AS id_certificadohistorico, ch.id_certificado AS id_certificado
                     FROM gtv.certificado_historico AS ch
                     GROUP BY id_certificado) AS sub ON sub.id_certificado = gt.id_certificado
         INNER JOIN gtv.certificado_historico AS ch ON ch.id_certificadohistorico = sub.id_certificadohistorico

         LEFT JOIN rh.pessoa AS ph ON ph.id = ch.id_pessoa
         LEFT JOIN rh.documento AS dh ON ph.id = dh.id_pessoa AND dh.id_documento_tipo IN (1, 2)

         INNER JOIN rh.pessoa AS pe ON pe.id = gt.id_pessoa_emissor
         LEFT JOIN rh.documento AS de ON pe.id = de.id_pessoa AND de.id_documento_tipo IN (1, 2)
         INNER JOIN rh.lotacao AS lote ON gt.id_lotacao = lote.id
         INNER JOIN rh.lotacao AS reg ON lote.id_lotacao_pai = reg.id

         INNER JOIN (SELECT gt.id_certificado        AS id,
                            count(gt.id_certificado) AS registros
                     FROM gtv.gtv AS gt
                              INNER JOIN gtv.produto_gtv AS pg ON pg.id_certificado = gt.id_certificado
                     GROUP BY gt.id_certificado) AS produtos ON produtos.id = gt.id_certificado

WHERE ce.ts_alteracao > :sql_last_value
ORDER BY pg.id_produto_gtv


