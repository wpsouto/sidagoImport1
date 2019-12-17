SELECT ie.id_inscricaoestadual                                                    AS id,

       case when prop.bo_ativo then 'Sim' else 'Não' end                          AS ativa,

       CASE WHEN mp.bo_brucelose THEN 'Sim' else 'Não' END                        AS marcacao_brucelose,
       CASE WHEN mp.bo_leucose THEN 'Sim' else 'Não' END                          AS marcacao_leucose,
       CASE WHEN mp.bo_antirrabica THEN 'Sim' else 'Não' END                      AS marcacao_antirrabica,
       CASE WHEN mp.bo_tuberculose THEN 'Sim' else 'Não' END                      AS marcacao_tuberculose,
       CASE WHEN mp.bo_vacinacaoassistida THEN 'Sim' else 'Não' END               AS marcacao_vacinacaoassistida,
       CASE WHEN mp.bo_sorologiavfa THEN 'Sim' else 'Não' END                     AS marcacao_scvvfa,
       CASE WHEN mp.bo_pncrc THEN 'Sim' else 'Não' END                            AS marcacao_pncrc,
       CASE WHEN mp.bo_mormo THEN 'Sim' else 'Não' END                            AS marcacao_mormo,
       CASE WHEN mp.bo_averbacaopenhora THEN 'Sim' else 'Não' END                 AS marcacao_averbacaopenhora,
       CASE WHEN mp.bo_livrebrucelose THEN 'Sim' else 'Não' END                   AS marcacao_livrebrucelose,
       CASE WHEN mp.bo_granjasuinolivreractopamina THEN 'Sim' else 'Não' END      AS marcacao_granjasuinolivreractopamina,
       CASE WHEN mp.bo_eras THEN 'Sim' else 'Não' END                             AS marcacao_eras,
       CASE WHEN mp.bo_pfe THEN 'Sim' else 'Não' END                              AS marcacao_pfe,
       CASE WHEN mp.bo_livrebrucelosetuberculose THEN 'Sim' else 'Não' END        AS marcacao_livrebrucelosetuberculose,
       CASE WHEN mp.bo_pestesuina THEN 'Sim' else 'Não' END                       AS marcacao_pestesuina,
       CASE WHEN mp.bo_aie THEN 'Sim' else 'Não' END                              AS marcacao_aie,
       CASE WHEN mp.bo_peae THEN 'Sim' else 'Não' END                             AS marcacao_peae,
       CASE WHEN mp.bo_confinamento THEN 'Sim' else 'Não' END                     AS marcacao_confinamento,
       CASE WHEN mp.bo_livretuberculose THEN 'Sim' else 'Não' END                 AS marcacao_livretuberculose,

       UPPER(p.nome)                                                              AS produtor_nome,
       d.numero                                                                   AS produtor_documento,

       ie.id_inscricaoestadual                                                    AS propriedade_id,
       UPPER(ie.no_fantasia)                                                      AS propriedade_nome,
       ie.nu_inscricaoestadual                                                    AS propriedade_ie,
       COALESCE(prop.vl_area, 0)                                                  AS propriedade_area,
       COALESCE(ie.vl_latitude, 0)                                                AS propriedade_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                               AS propriedade_gps_longitude,

       pai.nome                                                                   AS propriedade_regional_nome,
       ll.loc_no                                                                  AS propriedade_municipio_nome,
       ll.ufe_sg                                                                  AS propriedade_municipio_uf,
       ll.cod_ibge                                                                AS propriedade_municipio_ibge,
       COALESCE(ll.lat, 0)                                                        AS propriedade_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                        AS propriedade_municipio_gps_longitude,

       COALESCE(animal.total, 0)                                                  AS animal_total,
       case when COALESCE(animal.total, 0) > 0 then 'Sim' else 'Não' end          AS animal_existe,

       COALESCE(animal_bovideo.total, 0)                                          AS animal_bovideo_total,
       case when COALESCE(animal_bovideo.total, 0) > 0 then 'Sim' else 'Não' end  AS animal_bovideo_existe,

       COALESCE(animal_equideo.total, 0)                                          AS animal_equideo_total,
       case when COALESCE(animal_equideo.total, 0) > 0 then 'Sim' else 'Não' end  AS animal_equideo_existe,

       COALESCE(animal_suideo.total, 0)                                           AS animal_suideo_total,
       case when COALESCE(animal_suideo.total, 0) > 0 then 'Sim' else 'Não' end   AS animal_suideo_existe,

       COALESCE(animal_ave.total, 0)                                              AS animal_ave_total,
       case when COALESCE(animal_ave.total, 0) > 0 then 'Sim' else 'Não' end      AS animal_ave_existe,

       COALESCE(animal_caprino.total, 0)                                          AS animal_caprino_total,
       case when COALESCE(animal_caprino.total, 0) > 0 then 'Sim' else 'Não' end  AS animal_caprino_existe,

       COALESCE(animal_aquatico.total, 0)                                         AS animal_aquatico_total,
       case when COALESCE(animal_aquatico.total, 0) > 0 then 'Sim' else 'Não' end AS animal_aquatico_existe

FROM agrocomum.inscricaoestadual AS ie
         INNER JOIN agrocomum.propriedade AS prop ON prop.id_inscricaoestadual = ie.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS en ON iee.id_endereco = en.id_endereco
         INNER JOIN dne.log_localidade AS ll ON en.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON l.id_localidade = en.id_localidade AND l.bo_ativo = true AND id_lotacaotipo = 3 AND l.bo_organograma = true --Unidade Local
         INNER JOIN rh.lotacao AS pai ON pai.id = l.id_lotacao_pai AND pai.id_lotacaotipo = 2 AND pai.bo_ativo = true AND pai.bo_organograma = true --Unidade Regional
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN rh.documento AS d ON ie.id_pessoa = d.id_pessoa AND d.id_documento_tipo IN (1, 2)
         LEFT JOIN dsa.propriedade_marcacao_sanitaria AS mp ON mp.id_inscricaoestadual = ie.id_inscricaoestadual
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

ORDER BY ie.id_inscricaoestadual
