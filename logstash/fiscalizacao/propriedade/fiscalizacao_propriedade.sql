SELECT ie.id_inscricaoestadual                                                                                            AS id,
       ie.id_inscricaoestadual || '_' || EXTRACT(epoch from DATE_TRUNC('month', current_date - interval '0 month')::DATE) AS id_mes,
       UPPER(ie.no_fantasia)                                                                                              AS propriedade_nome,
       case when prop.bo_ativo then 'Sim' else 'Não' end                                                                  AS propriedade_ativa,
       case when COALESCE(tf.tf_quantidade, 0) > 0 then 'Sim' else 'Não' end                                              AS propriedade_fiscalizada,
       ie.nu_inscricaoestadual                                                                                            AS propriedade_ie,
       prop.nu_codigoanimal                                                                                               AS propriedade_codigo_animal,
       prop.nu_codigovegetal                                                                                              AS propriedade_codigo_vegetal,
       COALESCE(ie.vl_latitude, 0)                                                                                        AS propriedade_localizacao_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                                                                       AS propriedade_localizacao_gps_longitude,
       llr.nome                                                                                                           AS propriedade_regional_nome,
       ll.loc_no                                                                                                          AS propriedade_municipio_nome,
       ll.ufe_sg                                                                                                          AS propriedade_municipio_uf,
       COALESCE(ll.lat, 0)                                                                                                AS propriedade_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                                                                AS propriedade_municipio_gps_longitude,

       UPPER(p.nome)                                                                                                      AS produtor_nome,
       d.numero                                                                                                           AS produtor_documento,
       COALESCE(tf.tf_quantidade, 0)                                                                                      AS termo_fiscalizacao_quantidade,
       DATE_TRUNC('month', current_date - interval '0 month')::DATE                                                       AS termo_fiscalizacao_emissao,
       COALESCE(animal.total, 0)                                                                                          AS animal_total,
       case when COALESCE(animal.total, 0) > 0 then 'Sim' else 'Não' end                                                  AS animal_presente,
       COALESCE(vegetal.total, 0)                                                                                         AS vegetal_total,
       case when COALESCE(vegetal.total, 0) > 0 then 'Sim' else 'Não' end                                                 AS vegetal_presente

FROM agrocomum.inscricaoestadual AS ie
         INNER JOIN agrocomum.propriedade AS prop ON prop.id_inscricaoestadual = ie.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS e ON iee.id_endereco = e.id_endereco
         INNER JOIN dne.log_localidade AS ll ON e.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON ll.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN rh.documento AS d ON ie.id_pessoa = d.id_pessoa AND d.id_documento_tipo IN (1, 2)
         LEFT JOIN (SELECT ep.id_inscricaoestadual,
                           SUM(s.nu_saldo) AS total
                    FROM dsa.exploracao_propriedade AS ep
                             INNER JOIN dsa.nucleo AS n ON ep.id_exploracao = n.id_exploracao
                             INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
                    GROUP BY ep.id_inscricaoestadual) AS animal ON animal.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT up.id_inscricaoestadual,
                           COUNT(up.id_unidadeproducao) AS total
                    FROM gtv.unidade_producao AS up
                    WHERE up.bo_bloqueio = false
                    GROUP BY up.id_inscricaoestadual) AS vegetal ON vegetal.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN (SELECT tf.id_inscricaoestadual        AS tf_ie,
                           count(tf.id_termofiscalizacao) AS tf_quantidade
                    FROM fisc.termo_fiscalizacao AS tf
                    WHERE tf.ativo = true
                      AND tf.no_entidade = 'propriedade'
                      AND DATE_TRUNC('month', dt_criacaotermo)::DATE = DATE_TRUNC('month', current_date - interval '0 month')::DATE
                    GROUP BY tf_ie) AS tf ON tf.tf_ie = ie.id_inscricaoestadual
ORDER BY ie.id_inscricaoestadual
