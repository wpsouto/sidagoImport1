SELECT gem.id_estratificacaogta                               AS id,
       gt.id_gta                                              AS id_gta,
       gt.ts_emissao                                          AS emissao,
       case when gt.bo_ativo = TRUE then 'Não' else 'Sim' end AS cancelada,
       gem.nu_quantidade                                      AS quantidade,

       'Sim'                                                  AS gta_2020_emitida,

       'Sim'                                                  AS ativa,
       'Sim'                                                  AS animal_existe,
       CASE WHEN g.id = 1 THEN 'Sim' else 'Não' end           AS animal_bovideo_existe,
       CASE WHEN g.id = 2 THEN 'Sim' else 'Não' end           AS animal_equideo_existe,
       CASE WHEN g.id = 3 THEN 'Sim' else 'Não' end           AS animal_aquatico_existe,
       CASE WHEN g.id = 4 THEN 'Sim' else 'Não' end           AS animal_ave_existe,
       CASE WHEN g.id = 5 THEN 'Sim' else 'Não' end           AS animal_suideo_existe,
       CASE WHEN g.id = 10 THEN 'Sim' else 'Não' end          AS animal_caprino_existe,
       CASE
           WHEN g.id = 1 THEN 'Sim'
           WHEN g.id = 5 THEN 'Sim'
           WHEN g.id = 10 THEN 'Sim'
           ELSE 'Não'
           END                                                AS animal_febre_aftosa_existe,

       f.id_gta_finalidade                                    AS finalidade_id,
       f.no_finalidade                                        AS finalidade_nome,

       g.id                                                   AS grupo_id,
       g.no_grupo                                             AS grupo_nome,

       es.id                                                  AS especie_id,
       es.no_especie                                          AS especie_nome,

       UPPER(p.nome)                                          AS proprietario_nome,

       gto.id_origem                                          AS estabelecimento_id,
       gto.tp_origem                                          AS estabelecimento_tipo,
       UPPER(ie.no_fantasia)                                  AS estabelecimento_nome,
       ie.nu_inscricaoestadual                                AS estabelecimento_ie,
       llr.nome                                               AS estabelecimento_regional_nome,
       lo.loc_no                                              AS estabelecimento_municipio_nome,
       lo.ufe_sg                                              AS estabelecimento_municipio_uf,
       lo.cod_ibge                                            AS estabelecimento_municipio_ibge,
       COALESCE(lo.lat, 0)                                    AS estabelecimento_municipio_gps_latitude,
       COALESCE(lo.lon, 0)                                    AS estabelecimento_municipio_gps_longitude

FROM gta.gta as gt
         INNER JOIN gta.finalidade AS f ON gt.id_finalidade = f.id_finalidade
         INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
         INNER JOIN dsa.grupo AS g ON es.id_grupo = g.id
         INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = gto.id_origem
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN dne.log_localidade AS lo ON gto.id_municipio = lo.loc_nu
         INNER JOIN rh.lotacao AS l ON lo.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND l.bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional

         INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
         INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
WHERE EXTRACT(YEAR FROM gt.ts_emissao) = 2020
ORDER BY gt.id_gta ASC
