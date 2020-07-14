SELECT gem.id_estratificacaogta                                    AS id,
       gt.id_gta                                                   AS id_gta,
       gt.ts_emissao                                               AS emissao,
       case when gt.bo_ativo = TRUE then 'Não' else 'Sim' end      AS cancelada,
       'Sim'                                                       AS ativa,

       f.id_gta_finalidade                                         AS finalidade_id,
       f.no_finalidade                                             AS finalidade_nome,

       g.id                                                        AS grupo_id,
       g.no_grupo                                                  AS grupo_nome,

       es.id                                                       AS especie_id,
       es.no_especie                                               AS especie_nome,

       gtd.id_destino                                              AS destino_id,
       gtd.tp_destino                                              AS destino_tipo,
       COALESCE(UPPER(iev.no_fantasia), UPPER(ie.no_fantasia))     AS nome,
       COALESCE(iev.nu_inscricaoestadual, ie.nu_inscricaoestadual) AS ie,
       COALESCE(llrv.nome, llr.nome)                               AS regional_nome,
       COALESCE(ldv.loc_no, ld.loc_no)                             AS municipio_nome,
       COALESCE(ldv.ufe_sg, ld.ufe_sg)                             AS municipio_uf,
       COALESCE(ldv.cod_ibge, ld.cod_ibge)                         AS municipio_ibge,
       COALESCE(ld.lat, 0)                                         AS municipio_gps_latitude,
       COALESCE(ld.lon, 0)                                         AS municipio_gps_longitude,

       COALESCE(ldv.lat, COALESCE(ld.lat, 0))                      AS municipio_gps_latitude,
       COALESCE(ldv.lon, COALESCE(ld.lon, 0))                      AS municipio_gps_longitude

FROM gta.gta as gt
         INNER JOIN gta.finalidade AS f ON gt.id_finalidade = f.id_finalidade AND f.id_gta_finalidade = 0
         INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
         INNER JOIN dsa.grupo AS g ON es.id_grupo = g.id
         INNER JOIN gta.gta_destino AS gtd ON gt.id_gta = gtd.id_gta
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = gtd.id_destino
         INNER JOIN dne.log_localidade AS ld ON gtd.id_municipio = ld.loc_nu
         INNER JOIN rh.lotacao AS l ON ld.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND l.bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional

         LEFT JOIN agrocomum.inscricaoestadual AS iev ON iev.id_inscricaoestadual = gtd.id_destinovinculado
         LEFT JOIN dne.log_localidade AS ldv ON gtd.id_municipiovinculado = ldv.loc_nu
         LEFT JOIN rh.lotacao AS lv ON ldv.loc_nu = lv.id_localidade AND lv.id_lotacaotipo = 3 AND lv.bo_organograma = true--Unidade Local
         LEFT JOIN rh.lotacao AS llrv ON llrv.id = lv.id_lotacao_pai AND llrv.id_lotacaotipo = 2 --Unidade Regional

         INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
         INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
WHERE EXTRACT(YEAR FROM gt.ts_emissao) = 2019
ORDER BY gt.id_gta ASC
