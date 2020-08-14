SELECT ie.id_inscricaoestadual                                                                                                                                                AS id,

       case when prop.bo_ativo then 'Sim' else 'Não' end                                                                                                                      AS ativa,

       CASE WHEN mp.bo_tuberculose THEN 'Sim' else 'Não' END                                                                                                                  AS marcacao_tuberculose,
       CASE WHEN mp.bo_brucelose THEN 'Sim' else 'Não' END                                                                                                                    AS marcacao_brucelose,
       CASE WHEN mp.bo_mormo THEN 'Sim' else 'Não' END                                                                                                                        AS marcacao_mormo,
       CASE WHEN mp.bo_aie THEN 'Sim' else 'Não' END                                                                                                                          AS marcacao_aie,

       CASE
           WHEN mp.bo_tuberculose THEN 'Sim'
           WHEN mp.bo_brucelose THEN 'Sim'
           WHEN mp.bo_mormo THEN 'Sim'
           WHEN mp.bo_aie THEN 'Sim'
           ELSE 'Não'
           END                                                                                                                                                                  AS marcacao,

       CASE
           WHEN mp.bo_tuberculose THEN 'Tuberculose'
           WHEN mp.bo_brucelose THEN 'Brucelose'
           WHEN mp.bo_mormo THEN 'Mormo'
           WHEN mp.bo_aie THEN 'AIE'
           ELSE 'Não'
           END                                                                                                                                                                  AS marcacao_tipo,

       p.id                                                                                                                                                                   AS proprietario_id,
       UPPER(p.nome)                                                                                                                                                          AS proprietario_nome,

       case when usuario.id NOTNULL then 'Sim' else 'Não' end                                                                                                                 AS usuario_cadastrado,
       usuario.ativacao::DATE                                                                                                                                                 AS usuario_cadastro,
       EXTRACT(YEAR FROM usuario.ativacao)                                                                                                                                    AS usuario_cadastro_ano,
       EXTRACT(MONTH FROM usuario.ativacao)                                                                                                                                   AS usuario_cadastro_mes,
       EXTRACT(MONTH FROM usuario.ativacao) || '/' || EXTRACT(YEAR FROM usuario.ativacao)                                                                                     AS usuario_cadastro_mes_ano,

       ie.id_inscricaoestadual                                                                                                                                                AS estabelecimento_id,
       UPPER(ie.no_fantasia)                                                                                                                                                  AS estabelecimento_nome,
       ie.nu_inscricaoestadual                                                                                                                                                AS estabelecimento_ie,
       COALESCE(prop.vl_area, 0)                                                                                                                                              AS estabelecimento_area,
       ie.ts_inscricaoestadual                                                                                                                                                AS estabelecimento_cadastro,
       EXTRACT(YEAR FROM ie.ts_inscricaoestadual)                                                                                                                             AS estabelecimento_cadastro_ano,
       COALESCE(ie.vl_latitude, 0)                                                                                                                                            AS estabelecimento_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                                                                                                                           AS estabelecimento_gps_longitude,

       pai.nome                                                                                                                                                               AS estabelecimento_regional_nome,
       ll.loc_no                                                                                                                                                              AS estabelecimento_municipio_nome,
       ll.ufe_sg                                                                                                                                                              AS estabelecimento_municipio_uf,
       ll.cod_ibge                                                                                                                                                            AS estabelecimento_municipio_ibge,
       COALESCE(ll.lat, 0)                                                                                                                                                    AS estabelecimento_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                                                                                                                    AS estabelecimento_municipio_gps_longitude,

       gta_passado.emissao                                                                                                                                                    AS gta_passado_emissao,
       COALESCE(gta_passado.quantidade, 0)                                                                                                                                    AS gta_passado_quantidade,
       CASE WHEN COALESCE(gta_passado.quantidade, 0) > 0 THEN 'Sim' ELSE 'Não' end                                                                                            AS gta_passado_emitida,

       gta_atual.emissao                                                                                                                                                      AS gta_atual_emissao,
       COALESCE(gta_atual.quantidade, 0)                                                                                                                                      AS gta_atual_quantidade,
       CASE WHEN COALESCE(gta_atual.quantidade, 0) > 0 THEN 'Sim' ELSE 'Não' end                                                                                              AS gta_atual_emitida,

       tf.emissao                                                                                                                                                             AS tf_emissao,
       COALESCE(tf.quantidade, 0)                                                                                                                                             AS tf_quantidade,
       CASE WHEN ROUND((extract(DAY FROM CURRENT_DATE - COALESCE(tf.emissao, current_date - interval '5 year')::TIMESTAMP) / 30):: NUMERIC, 0) > 60 THEN 'Não' ELSE 'Sim' end AS tf_fiscalizado,
       ROUND((extract(DAY FROM CURRENT_DATE - COALESCE(tf.emissao, current_date - interval '5 year')::TIMESTAMP) / 30):: NUMERIC, 0)                                          AS tf_mes,

       COALESCE(animal.total, 0)                                                                                                                                              AS animal_total,
       case when COALESCE(animal.total, 0) > 0 then 'Sim' else 'Não' end                                                                                                      AS animal_existe,

       COALESCE(animal_bovideo.total, 0)                                                                                                                                      AS animal_bovideo_total,
       case when COALESCE(animal_bovideo.total, 0) > 0 then 'Sim' else 'Não' end                                                                                              AS animal_bovideo_existe,

       COALESCE(animal_equideo.total, 0)                                                                                                                                      AS animal_equideo_total,
       case when COALESCE(animal_equideo.total, 0) > 0 then 'Sim' else 'Não' end                                                                                              AS animal_equideo_existe,

       COALESCE(animal_suideo.total, 0)                                                                                                                                       AS animal_suideo_total,
       case when COALESCE(animal_suideo.total, 0) > 0 then 'Sim' else 'Não' end                                                                                               AS animal_suideo_existe,

       COALESCE(animal_ave.total, 0)                                                                                                                                          AS animal_ave_total,
       case when COALESCE(animal_ave.total, 0) > 0 then 'Sim' else 'Não' end                                                                                                  AS animal_ave_existe,

       COALESCE(animal_caprino.total, 0)                                                                                                                                      AS animal_caprino_total,
       case when COALESCE(animal_caprino.total, 0) > 0 then 'Sim' else 'Não' end                                                                                              AS animal_caprino_existe,

       COALESCE(animal_aquatico.total, 0)                                                                                                                                     AS animal_aquatico_total,
       case when COALESCE(animal_aquatico.total, 0) > 0 then 'Sim' else 'Não' end                                                                                             AS animal_aquatico_existe,

       COALESCE(animal_bovideo.total, 0) + COALESCE(animal_suideo.total, 0) + COALESCE(animal_caprino.total, 0)                                                               AS animal_febre_aftosa_total,
       CASE
           WHEN COALESCE(animal_bovideo.total, 0) > 0 THEN 'Sim'
           WHEN COALESCE(animal_suideo.total, 0) > 0 THEN 'Sim'
           WHEN COALESCE(animal_caprino.total, 0) > 0 THEN 'Sim'
           ELSE 'Não'
           END                                                                                                                                                                  AS animal_febre_aftosa_existe

FROM agrocomum.inscricaoestadual AS ie
         INNER JOIN agrocomum.propriedade AS prop ON prop.id_inscricaoestadual = ie.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS en ON iee.id_endereco = en.id_endereco
         INNER JOIN dne.log_localidade AS ll ON en.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON l.id_localidade = en.id_localidade AND l.bo_ativo = true AND id_lotacaotipo = 3 AND l.bo_organograma = true --Unidade Local
         INNER JOIN rh.lotacao AS pai ON pai.id = l.id_lotacao_pai AND pai.id_lotacaotipo = 2 AND pai.bo_ativo = true AND pai.bo_organograma = true --Unidade Regional
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
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
                      AND es.id_grupo = 3
                    GROUP BY ep.id_inscricaoestadual) AS animal_aquatico ON animal_aquatico.id_inscricaoestadual = ie.id_inscricaoestadual
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
                      AND es.id_grupo = 5
                    GROUP BY ep.id_inscricaoestadual) AS animal_suideo ON animal_suideo.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                             INNER JOIN dsa.especie AS es ON n.id_especie = es.id
                    WHERE ep.bo_ativo = true
                      AND es.id_grupo = 10
                    GROUP BY ep.id_inscricaoestadual) AS animal_caprino ON animal_caprino.id_inscricaoestadual = ie.id_inscricaoestadual

         LEFT JOIN (SELECT tf.id_inscricaoestadual        AS ie,
                           COUNT(tf.id_termofiscalizacao) AS quantidade,
                           MAX(tf.dt_criacaotermo)        AS emissao
                    FROM fisc.termo_fiscalizacao AS tf
                    WHERE tf.tp_caracterizacao = 'AN'
                      AND DATE_PART('year', tf.dt_criacaotermo) >= DATE_PART('year', current_date - interval '5 year')
                      AND tf.ativo = true
                    GROUP BY ie) AS tf ON tf.ie = ie.id_inscricaoestadual

         LEFT JOIN (SELECT gto.id_origem      AS ie,
                           COUNT(gt.id_gta)   AS quantidade,
                           MAX(gt.ts_emissao) AS emissao
                    FROM gta.gta as gt
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE EXTRACT(YEAR FROM gt.ts_emissao) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
                      AND gt.bo_ativo = TRUE
                    GROUP BY ie) AS gta_passado ON gta_passado.ie = ie.id_inscricaoestadual

         LEFT JOIN (SELECT gto.id_origem      AS ie,
                           COUNT(gt.id_gta)   AS quantidade,
                           MAX(gt.ts_emissao) AS emissao
                    FROM gta.gta as gt
                             INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta AND gto.tp_origem = 'propriedade'
                    WHERE EXTRACT(YEAR FROM gt.ts_emissao) = EXTRACT(YEAR FROM CURRENT_DATE)
                      AND gt.bo_ativo = TRUE
                    GROUP BY ie) AS gta_atual ON gta_atual.ie = ie.id_inscricaoestadual

         LEFT JOIN (SELECT DISTINCT u.id_pessoa                                AS id,
                                    MAX(COALESCE(h.dt_cadastro, u.ts_usuario)) AS ativacao
                    FROM rh.usuario u
                             LEFT JOIN rh.primeiro_acesso_historico h ON h.id_pessoa_solicitante = u.id_pessoa AND h.bo_aprovado
                    WHERE u.inativo = false
                    GROUP BY u.id_pessoa) AS usuario ON p.id = usuario.id

ORDER BY ie.id_inscricaoestadual
