SELECT ie.id_inscricaoestadual                                                                                        AS id,

       case when prop.bo_ativo then 'Sim' else 'Não' end                                                              AS ativa,

       UPPER(p.nome)                                                                                                  AS produtor_nome,
       d.numero                                                                                                       AS produtor_documento,

       ie.id_inscricaoestadual                                                                                        AS propriedade_id,
       UPPER(ie.no_fantasia)                                                                                          AS propriedade_nome,
       ie.nu_inscricaoestadual                                                                                        AS propriedade_ie,
       COALESCE(prop.vl_area, 0)                                                                                      AS propriedade_area,
       COALESCE(ie.vl_latitude, 0)                                                                                    AS propriedade_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                                                                   AS propriedade_gps_longitude,

       pai.nome                                                                                                       AS propriedade_regional_nome,
       ll.loc_no                                                                                                      AS propriedade_municipio_nome,
       ll.ufe_sg                                                                                                      AS propriedade_municipio_uf,
       ll.cod_ibge                                                                                                    AS propriedade_municipio_ibge,
       COALESCE(ll.lat, 0)                                                                                            AS propriedade_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                                                            AS propriedade_municipio_gps_longitude,

       tf.emissao                                                                                                     AS tf_emissao,
       COALESCE(tf.quantidade, 0)                                                                                     AS tf_quantidade,
       CASE WHEN COALESCE(tf.quantidade, 0) > 0 THEN 'Não' ELSE 'Sim' end                                             AS tf_fiscalizado,

       gta.emissao                                                                                                    AS gta_emissao,
       COALESCE(gta.quantidade, 0)                                                                                    AS gta_quantidade,
       CASE WHEN COALESCE(gta.quantidade, 0) > 0 THEN 'Sim' ELSE 'Não' end                                            AS gta_emitida,
       COALESCE(gta_bovideo.quantidade, 0) + COALESCE(gta_equideo.quantidade, 0) + COALESCE(gta_suideo.quantidade, 0) +
       COALESCE(gta_ave.quantidade, 0) + COALESCE(gta_caprino.quantidade, 0) + COALESCE(gta_aquatico.quantidade, 0)   AS gta_total_aminal,
       COALESCE(gta_bovideo.quantidade, 0)                                                                            AS gta_bovideo,
       COALESCE(gta_equideo.quantidade, 0)                                                                            AS gta_equideo,
       COALESCE(gta_suideo.quantidade, 0)                                                                             AS gta_suideo,
       COALESCE(gta_ave.quantidade, 0)                                                                                AS gta_ave,
       COALESCE(gta_caprino.quantidade, 0)                                                                            AS gta_caprino,
       COALESCE(gta_aquatico.quantidade, 0)                                                                           AS gta_aquatico,
       COALESCE(gta_bovideo.quantidade, 0) + COALESCE(gta_suideo.quantidade, 0) + COALESCE(gta_caprino.quantidade, 0) AS gta_febre_aftosa,

       COALESCE(animal.total, 0)                                                                                      AS animal_total,
       case when COALESCE(animal.total, 0) > 0 then 'Sim' else 'Não' end                                              AS animal_existe,

       COALESCE(animal_bovideo.total, 0)                                                                              AS animal_bovideo_total,
       case when COALESCE(animal_bovideo.total, 0) > 0 then 'Sim' else 'Não' end                                      AS animal_bovideo_existe,

       COALESCE(animal_equideo.total, 0)                                                                              AS animal_equideo_total,
       case when COALESCE(animal_equideo.total, 0) > 0 then 'Sim' else 'Não' end                                      AS animal_equideo_existe,

       COALESCE(animal_suideo.total, 0)                                                                               AS animal_suideo_total,
       case when COALESCE(animal_suideo.total, 0) > 0 then 'Sim' else 'Não' end                                       AS animal_suideo_existe,

       COALESCE(animal_ave.total, 0)                                                                                  AS animal_ave_total,
       case when COALESCE(animal_ave.total, 0) > 0 then 'Sim' else 'Não' end                                          AS animal_ave_existe,

       COALESCE(animal_caprino.total, 0)                                                                              AS animal_caprino_total,
       case when COALESCE(animal_caprino.total, 0) > 0 then 'Sim' else 'Não' end                                      AS animal_caprino_existe,

       COALESCE(animal_aquatico.total, 0)                                                                             AS animal_aquatico_total,
       case when COALESCE(animal_aquatico.total, 0) > 0 then 'Sim' else 'Não' end                                     AS animal_aquatico_existe,

       COALESCE(animal_bovideo.total, 0) + COALESCE(animal_suideo.total, 0) + COALESCE(animal_caprino.total, 0)       AS animal_febre_aftosa_total,
       CASE
           WHEN COALESCE(animal_bovideo.total, 0) > 0 THEN 'Sim'
           WHEN COALESCE(animal_suideo.total, 0) > 0 THEN 'Sim'
           WHEN COALESCE(animal_caprino.total, 0) > 0 THEN 'Sim'
           ELSE 'Não'
           END                                                                                                        AS animal_febre_aftosa_existe

FROM agrocomum.inscricaoestadual AS ie
         INNER JOIN agrocomum.propriedade AS prop ON prop.id_inscricaoestadual = ie.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS en ON iee.id_endereco = en.id_endereco
         INNER JOIN dne.log_localidade AS ll ON en.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON l.id_localidade = en.id_localidade AND l.bo_ativo = true AND id_lotacaotipo = 3 AND l.bo_organograma = true --Unidade Local
         INNER JOIN rh.lotacao AS pai ON pai.id = l.id_lotacao_pai AND pai.id_lotacaotipo = 2 AND pai.bo_ativo = true AND pai.bo_organograma = true --Unidade Regional
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN rh.documento AS d ON ie.id_pessoa = d.id_pessoa AND d.id_documento_tipo IN (1, 2)
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                    WHERE ep.bo_ativo = true
                    GROUP BY ep.id_inscricaoestadual) AS animal ON animal.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                             INNER JOIN dsa.especie AS es ON n.id_especie = es.id
                    WHERE ep.bo_ativo = true
                      AND es.id_grupo = 1
                    GROUP BY ep.id_inscricaoestadual) AS animal_bovideo ON animal_bovideo.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                             INNER JOIN dsa.especie AS es ON n.id_especie = es.id
                    WHERE ep.bo_ativo = true
                      AND es.id_grupo = 2
                    GROUP BY ep.id_inscricaoestadual) AS animal_equideo ON animal_equideo.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                             INNER JOIN dsa.especie AS es ON n.id_especie = es.id
                    WHERE ep.bo_ativo = true
                      AND es.id_grupo = 5
                    GROUP BY ep.id_inscricaoestadual) AS animal_suideo ON animal_suideo.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                             INNER JOIN dsa.especie AS es ON n.id_especie = es.id
                    WHERE ep.bo_ativo = true
                      AND es.id_grupo = 4
                    GROUP BY ep.id_inscricaoestadual) AS animal_ave ON animal_ave.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                             INNER JOIN dsa.especie AS es ON n.id_especie = es.id
                    WHERE ep.bo_ativo = true
                      AND es.id_grupo = 10
                    GROUP BY ep.id_inscricaoestadual) AS animal_caprino ON animal_caprino.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                             INNER JOIN dsa.especie AS es ON n.id_especie = es.id
                    WHERE ep.bo_ativo = true
                      AND es.id_grupo = 3
                    GROUP BY ep.id_inscricaoestadual) AS animal_aquatico ON animal_aquatico.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT tf.id_inscricaoestadual        AS ie,
                           COUNT(tf.id_termofiscalizacao) AS quantidade,
                           MAX(tf.dt_criacaotermo)        AS emissao
                    FROM fisc.termo_fiscalizacao AS tf
                    WHERE tf.tp_caracterizacao = 'AN'
                      AND DATE_PART('year', tf.dt_criacaotermo) >= DATE_PART('year', current_date - interval '1 year')
                      AND tf.ativo = true
                    GROUP BY ie) AS tf ON tf.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT gto.id_origem                       AS ie,
                           SUM(COALESCE(gem.nu_quantidade, 0)) AS quantidade
                    FROM gta.gta as gt
                             INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE DATE_PART('year', gt.ts_emissao) = DATE_PART('year', current_date - interval '1 year')
                      AND gt.bo_ativo = TRUE
                      AND es.id_grupo = 1
                    GROUP BY gto.id_origem) AS gta_bovideo ON gta_bovideo.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT gto.id_origem                       AS ie,
                           SUM(COALESCE(gem.nu_quantidade, 0)) AS quantidade
                    FROM gta.gta as gt
                             INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE DATE_PART('year', gt.ts_emissao) = DATE_PART('year', current_date - interval '1 year')
                      AND gt.bo_ativo = TRUE
                      AND es.id_grupo = 2
                    GROUP BY gto.id_origem) AS gta_equideo ON gta_equideo.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT gto.id_origem                       AS ie,
                           SUM(COALESCE(gem.nu_quantidade, 0)) AS quantidade
                    FROM gta.gta as gt
                             INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE DATE_PART('year', gt.ts_emissao) = DATE_PART('year', current_date - interval '1 year')
                      AND gt.bo_ativo = TRUE
                      AND es.id_grupo = 5
                    GROUP BY gto.id_origem) AS gta_suideo ON gta_suideo.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT gto.id_origem                       AS ie,
                           SUM(COALESCE(gem.nu_quantidade, 0)) AS quantidade
                    FROM gta.gta as gt
                             INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE DATE_PART('year', gt.ts_emissao) = DATE_PART('year', current_date - interval '1 year')
                      AND gt.bo_ativo = TRUE
                      AND es.id_grupo = 4
                    GROUP BY gto.id_origem) AS gta_ave ON gta_ave.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT gto.id_origem                       AS ie,
                           SUM(COALESCE(gem.nu_quantidade, 0)) AS quantidade
                    FROM gta.gta as gt
                             INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE DATE_PART('year', gt.ts_emissao) = DATE_PART('year', current_date - interval '1 year')
                      AND gt.bo_ativo = TRUE
                      AND es.id_grupo = 10
                    GROUP BY gto.id_origem) AS gta_caprino ON gta_caprino.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT gto.id_origem                       AS ie,
                           SUM(COALESCE(gem.nu_quantidade, 0)) AS quantidade
                    FROM gta.gta as gt
                             INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE DATE_PART('year', gt.ts_emissao) = DATE_PART('year', current_date - interval '1 year')
                      AND gt.bo_ativo = TRUE
                      AND es.id_grupo = 3
                    GROUP BY gto.id_origem) AS gta_aquatico ON gta_aquatico.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT gto.id_origem      AS ie,
                           COUNT(gt.id_gta)   AS quantidade,
                           MAX(gt.ts_emissao) AS emissao
                    FROM gta.gta as gt
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE DATE_PART('year', gt.ts_emissao) = DATE_PART('year', current_date - interval '1 year')
                      AND gt.bo_ativo = TRUE
                    GROUP BY ie) AS gta ON gta.ie = ie.id_inscricaoestadual
ORDER BY ie.id_inscricaoestadual
