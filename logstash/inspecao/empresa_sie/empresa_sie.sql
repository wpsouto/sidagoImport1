SELECT ie.id_inscricaoestadual                                     AS id,

       empresa_situacao_cadastral_kibana(ie.id_inscricaoestadual,
                                         ie.id_classificacao,
                                         ie.id_situacaocadastral,
                                         ie.dt_credenciamento,
                                         b.idEtapaBDAtual,
                                         b.dtVencimentoEtapa)      AS situacao_cadastral,

       CASE
           WHEN ie.id_situacaocadastral = 5 THEN 'Não'
           WHEN ie.id_situacaocadastral = 6 THEN 'Não'
           WHEN ie.id_situacaocadastral = 8 THEN 'Não'
           ELSE 'Sim'
           END                                                     AS ativa,

       empresa_situacao_financeira_kibana(ie.id_inscricaoestadual) AS situacao_financeira,

       UPPER(ie.no_fantasia)                                       AS nome,
       c.ds_classificacao                                          AS classificacao,
       ie.nu_inscricaoestadual                                     AS ie,
       COALESCE(ie.vl_latitude, 0)                                 AS gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                AS gps_longitude,
       llr.nome                                                    AS regional_nome,
       ll.loc_no                                                   AS municipio_nome,
       ll.ufe_sg                                                   AS municipio_uf,
       ll.cod_ibge                                                 AS municipio_ibge,
       COALESCE(ll.lat, 0)                                         AS municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                         AS municipio_gps_longitude,

       ie.dt_credenciamento                                        AS credenciamento_data,
       CURRENT_DATE - ie.dt_credenciamento                         AS credenciamento_dias

FROM agrocomum.empresa emp
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = emp.id_inscricaoestadual
         INNER JOIN agrocomum.classificacao AS c ON ie.id_classificacao = c.id_classificacao
         INNER JOIN agrocomum.classificacao_macro_composta AS cmc ON cmc.id_classificacaooriginal = c.id_classificacao AND cmc.id_classificacaomacro = 1
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS e ON iee.id_endereco = e.id_endereco
         INNER JOIN dne.log_localidade AS ll ON e.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON ll.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional
         INNER JOIN rh.pessoa AS pe ON pe.id = ie.id_pessoa
         INNER JOIN (SELECT e.id_etaparecadastramento AS idEtapaBDAtual, e.dt_vencimentoetapa AS dtVencimentoEtapa, e.ano AS ano
                     FROM agrocomum.etapa_recadastramento AS e
                     WHERE e.ano = date_part('year', CURRENT_DATE)::text
                     ORDER BY e.ano DESC
                              LIMIT '1') AS b ON 1 = 1
ORDER BY ie.id_inscricaoestadual
