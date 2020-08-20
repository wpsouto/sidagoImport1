SELECT l.id_confirmacaoabatelote || '-' || COALESCE(lc.id_linhacondenacao, 0) AS id,
       l.dt_inspecao                                                          AS emissao,

       l.id_linha                                                             AS linha_id,

       case when l.bo_ativo then 'Não' else 'Sim' end                         AS cancelada,

       gta.animal                                                             AS gta_animal,
       gta.quantidade                                                         AS gta_quantidade,

       ie.id_inscricaoestadual                                                AS empresa_id,
       ie.no_fantasia                                                         AS empresa_nome,
       ie.nu_inscricaoestadual                                                AS empresa_ie,

       prop.id_inscricaoestadual                                              AS propriedade_id,
       prop.no_fantasia                                                       AS propriedade_nome,
       prop.nu_inscricaoestadual                                              AS propriedade_ie,
       COALESCE(prop.vl_latitude, 0)                                          AS propriedade_gps_latitude,
       COALESCE(prop.vl_longitude, 0)                                         AS propriedade_gps_longitude,

       ll.loc_no                                                              AS propriedade_municipio_nome,
       ll.ufe_sg                                                              AS propriedade_municipio_uf,
       ll.cod_ibge                                                            AS propriedade_municipio_ibge,
       COALESCE(ll.lat, 0)                                                    AS propriedade_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                    AS propriedade_municipio_gps_longitude,

       pf.id                                                                  AS fiscal_id,
       pf.nome                                                                AS fiscal_nome,

       case when lc.id_linha NOTNULL then 'Sim' else 'Não' end                AS condenacao,

       g.id                                                                   AS grupo_id,
       g.no_grupo                                                             AS grupo_nome,
       pr.id_produto                                                          AS produto_id,
       pr.no_produto                                                          AS produto_nome,

       CASE
           WHEN lc.tp_condenacao = 'p' THEN 'Condenação Parcial'
           WHEN lc.tp_condenacao = 't' THEN 'Condenação Total'
           WHEN lc.tp_condenacao = 'ac' THEN 'Aproveitamento Condicional'
           WHEN lc.tp_condenacao = 'liberacao' THEN 'Liberacao'
           WHEN lc.tp_condenacao = 'retorno_origem' THEN 'Retorno Origem'
           END                                                                AS julgamento,

       lc.ds_destinacao                                                       AS destinacao,
       lc.nu_quantidade                                                       AS quantidade,

       d.id_doenca                                                            AS doenca_id,
       d.no_doenca                                                            AS doenca_nome,

       CASE
           WHEN d.tp_inspecao NOTNULL THEN 'Ante Mortem'
           WHEN lc.id_linha NOTNULL THEN 'Post Mortem'
           END                                                                AS tipo_inspecao

FROM inspecao.linha AS l
         INNER JOIN rh.pessoa AS pf ON l.id_pessoa_fiscal = pf.id
         INNER JOIN inspecao.confirmacao_abate_lote AS cal ON l.id_confirmacaoabatelote = cal.id_confirmacaoabatelote
         INNER JOIN agrocomum.inscricaoestadual AS prop ON cal.id_inscricaoestadual_origem = prop.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON prop.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS en ON iee.id_endereco = en.id_endereco
         INNER JOIN dne.log_localidade AS ll ON en.id_localidade = ll.loc_nu

         INNER JOIN dsa.especie AS es ON cal.id_especie = es.id
         INNER JOIN dsa.grupo AS g ON es.id_grupo = g.id
         INNER JOIN agrocomum.inscricaoestadual AS ie ON l.id_inscricaoestadual = ie.id_inscricaoestadual

         LEFT JOIN inspecao.linha_condenacao AS lc ON lc.id_linha = l.id_linha
         LEFT JOIN inspecao.produto AS pr ON pr.id_produto = lc.id_produto
         LEFT JOIN inspecao.doenca AS d ON d.id_doenca = lc.id_doenca
         LEFT JOIN (SELECT calg.id_confirmacaoabatelote AS id,
                           SUM(gem.nu_quantidade)       AS animal,
                           COUNT(DISTINCT gt.id_gta)    AS quantidade
                    FROM inspecao.confirmacao_abate_lote_gta AS calg
                             INNER JOIN gta.gta AS gt ON calg.id_gta = gt.id_gta
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                    GROUP BY calg.id_confirmacaoabatelote) AS gta ON cal.id_confirmacaoabatelote = gta.id

WHERE l.dt_lancamento:: date >= current_date - interval '1 month'
ORDER BY l.id_confirmacaoabatelote
