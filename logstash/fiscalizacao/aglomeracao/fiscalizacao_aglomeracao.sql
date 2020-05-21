SELECT ac.id_aglomeracaociclo                          AS id,
       ac.nu_evento                                    AS numero,
       ac.ts_inicio                                    AS inicio,
       ac.ts_fim                                       AS fim,
       ac.ts_cadastro                                  AS cadastro,
       c.ds_classificacao                              AS classificacao,
       case when ac.bo_ativo then 'Não' else 'Sim' end AS cancelada,

       (SELECT case when COUNT(tf.id_termofiscalizacao) != 0 then 'Sim' else 'Não' end
        FROM fisc.termo_fiscalizacao AS tf
        WHERE ie.id_pessoa = tf.id_entidade
          and (tf.dt_criacaotermo BETWEEN ac.ts_inicio and ac.ts_fim)
          and tf.bo_evento = true)                     AS vistoriado,

       (SELECT COALESCE(SUM(tro.nu_quantidade), 0)
        FROM fisc.termo_fiscalizacao AS tf
                 INNER JOIN fisc.termoobjetivo_fiscalizacao AS tro ON tf.id_termofiscalizacao = tro.id_termofiscalizacao
        WHERE ie.id_pessoa = tf.id_entidade
          and (tf.dt_criacaotermo BETWEEN ac.ts_inicio and ac.ts_fim)
          and tf.bo_evento = true)                     AS animal_vistoriado_total,


       COALESCE(aet.total, 0)                          AS animal_entrada_total,
       COALESCE(act.total, 0)                          AS animal_confirmado_total,

       COALESCE(aebo.total, 0)                         AS animal_entrada_bovideo,
       COALESCE(aee.total, 0)                          AS animal_entrada_equideo,
       COALESCE(aeco.total, 0)                         AS animal_entrada_caprino_ovino,

       ie.id_inscricaoestadual                         AS fiscalizado_id,
       ie.no_fantasia                                  AS fiscalizado_nome,
       ie.nu_inscricaoestadual                         AS fiscalizado_ie,
       COALESCE(ie.vl_latitude, 0)                     AS fiscalizado_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                    AS fiscalizado_gps_longitude,
       ll.cod_ibge                                     AS fiscalizado_municipio_ibge,
       ll.loc_no                                       AS fiscalizado_municipio_nome,
       ll.ufe_sg                                       AS fiscalizado_municipio_uf,
       COALESCE(ll.lat, 0)                             AS fiscalizado_municipio_localizacao_latitude,
       COALESCE(ll.lon, 0)                             AS fiscalizado_municipio_localizacao_longitude,
       pai.nome                                        AS fiscalizado_regional_nome

FROM agrocomum.inscricaoestadual AS ie
         INNER JOIN dsa.aglomeracao_ciclo AS ac ON ac.id_inscricaoestadual = ie.id_inscricaoestadual
         INNER JOIN agrocomum.classificacao AS c ON ie.id_classificacao = c.id_classificacao
         INNER JOIN agrocomum.classificacao_macro_composta AS cmc
                    ON cmc.id_classificacaooriginal = c.id_classificacao AND cmc.id_classificacaomacro = 5
         INNER JOIN dne.log_localidade AS ll ON ll.loc_nu = ac.id_localidade
         INNER JOIN rh.lotacao AS l
                    ON l.id_localidade = ac.id_localidade and l.bo_ativo = true and l.bo_organograma = true and id_lotacaotipo = 3
         INNER JOIN rh.lotacao AS pai ON pai.id = l.id_lotacao_pai

         LEFT JOIN (SELECT ac.id_aglomeracaociclo AS id,
                           SUM(gem.nu_quantidade) AS total
                    FROM gta.gta_destino AS gt
                             INNER JOIN dsa.aglomeracao_ciclo AS ac ON gt.id_destinovinculado = ac.id_aglomeracaociclo
                             INNER JOIN gta.gta AS gta ON gta.id_gta = gt.id_gta
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN dsa.estratificacao AS es ON gem.id_estratificacao = es.id
                    WHERE gt.tp_destino = 'aglomeracao'
                      AND gta.bo_ativo = TRUE
                    GROUP BY ac.id_aglomeracaociclo) AS aet ON aet.id = ac.id_aglomeracaociclo

         LEFT JOIN (SELECT ac.id_aglomeracaociclo AS id,
                           SUM(gem.nu_quantidade) AS total
                    FROM gta.gta_destino AS gt
                             INNER JOIN dsa.aglomeracao_ciclo AS ac ON gt.id_destinovinculado = ac.id_aglomeracaociclo
                             INNER JOIN gta.gta AS gta ON gta.id_gta = gt.id_gta
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN dsa.estratificacao AS es ON gem.id_estratificacao = es.id
                    WHERE gt.tp_destino = 'aglomeracao'
                      AND gta.bo_ativo = TRUE
                      AND gta.bo_confirmada = TRUE
                    GROUP BY ac.id_aglomeracaociclo) AS act ON act.id = ac.id_aglomeracaociclo

         LEFT JOIN (SELECT ac.id_aglomeracaociclo              AS id,
                           COALESCE(SUM(gem.nu_quantidade), 0) AS total
                    FROM gta.gta_destino AS gt
                             INNER JOIN dsa.aglomeracao_ciclo AS ac ON gt.id_destinovinculado = ac.id_aglomeracaociclo
                             INNER JOIN gta.gta AS gta ON gta.id_gta = gt.id_gta
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN dsa.estratificacao AS es ON gem.id_estratificacao = es.id
                    WHERE gt.id_destinovinculado = ac.id_aglomeracaociclo
                      AND gt.tp_destino = 'aglomeracao'
                      AND es.id_especie IN (1, 2) --Bovídeos
                      AND gta.bo_ativo = TRUE
                    GROUP BY ac.id_aglomeracaociclo) AS aebo ON aebo.id = ac.id_aglomeracaociclo

         LEFT JOIN (SELECT ac.id_aglomeracaociclo              AS id,
                           COALESCE(SUM(gem.nu_quantidade), 0) AS total
                    FROM gta.gta_destino AS gt
                             INNER JOIN dsa.aglomeracao_ciclo AS ac ON gt.id_destinovinculado = ac.id_aglomeracaociclo
                             INNER JOIN gta.gta AS gta ON gta.id_gta = gt.id_gta
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN dsa.estratificacao AS es ON gem.id_estratificacao = es.id
                    WHERE gt.id_destinovinculado = ac.id_aglomeracaociclo
                      AND gt.tp_destino = 'aglomeracao'
                      AND es.id_especie in (5, 6, 7)--Equídeos
                      AND gta.bo_ativo = TRUE
                    GROUP BY ac.id_aglomeracaociclo) AS aee ON aee.id = ac.id_aglomeracaociclo

         LEFT JOIN (SELECT ac.id_aglomeracaociclo              AS id,
                           COALESCE(SUM(gem.nu_quantidade), 0) AS total
                    FROM gta.gta_destino AS gt
                             INNER JOIN dsa.aglomeracao_ciclo AS ac ON gt.id_destinovinculado = ac.id_aglomeracaociclo
                             INNER JOIN gta.gta AS gta ON gta.id_gta = gt.id_gta
                             INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                             INNER JOIN dsa.estratificacao AS es ON gem.id_estratificacao = es.id
                    WHERE gt.id_destinovinculado = ac.id_aglomeracaociclo
                      AND gt.tp_destino = 'aglomeracao'
                      AND es.id_especie IN (3, 4) --CAPRINO/OVINO
                      AND gta.bo_ativo = TRUE
                    GROUP BY ac.id_aglomeracaociclo) AS aeco ON aeco.id = ac.id_aglomeracaociclo

WHERE ac.ts_cadastro::date >= current_date - interval '2 month'
ORDER BY ac.id_aglomeracaociclo
