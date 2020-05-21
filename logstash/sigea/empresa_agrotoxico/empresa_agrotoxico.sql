SELECT ie.id_inscricaoestadual                                                                          AS id,
       ie.id_situacaocadastral                                                                          AS empresa_situacao_id,
       CASE
           WHEN ie.id_situacaocadastral = 5 THEN 'SUSPENSA'
           WHEN ie.id_situacaocadastral = 6 THEN 'DESCREDENCIADA'
           WHEN ie.id_situacaocadastral = 8 THEN 'ERRO CADASTRO'
           ELSE 'ATIVA'
           END                                                                                            AS empresa_situacao_descricao,

       UPPER(ie.no_fantasia)                                                                            AS empresa_nome,
       d.numero                                                                                         AS empresa_cnpj,
       c.ds_classificacao                                                                               AS empresa_classificacao,
       ie.nu_inscricaoestadual                                                                          AS empresa_ie,
       COALESCE(ie.vl_latitude, 0)                                                                      AS empresa_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                                                     AS empresa_gps_longitude,
       llr.nome                                                                                         AS empresa_regional_nome,
       ll.loc_no                                                                                        AS empresa_municipio_nome,
       ll.ufe_sg                                                                                        AS empresa_municipio_uf,
       ll.cod_ibge                                                                                      AS empresa_municipio_ibge,
       COALESCE(ll.lat, 0)                                                                              AS empresa_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                                              AS empresa_municipio_gps_longitude,

       ie.dt_credenciamento                                                                             AS empresa_credenciamento_data,
       CURRENT_DATE - ie.dt_credenciamento                                                              AS empresa_credenciamento_dias,

       tf.emissao                                                                                       AS tf_emissao,
       COALESCE(tf.quantidade, 0)                                                                       AS tf_quantidade,
       CASE WHEN COALESCE(tf.quantidade, 0) > 0 THEN 'Sim' ELSE 'Não' end                               AS tf_fiscalizado,
       DIV((((DATE_PART('year', CURRENT_DATE) - DATE_PART('year', ie.dt_credenciamento)) * 12) +
            (DATE_PART('month', CURRENT_DATE) - DATE_PART('month', ie.dt_credenciamento)))::NUMERIC, 4) AS tf_meta_quantidade,

       receita.emissao                                                                                  AS receita_emissao,
       receita.envio                                                                                    AS receita_envio,
       COALESCE(receita.quantidade, 0)                                                                  AS receita_quantidade,
       CASE WHEN COALESCE(receita.quantidade, 0) > 0 THEN 'Sim' ELSE 'Não' end                          AS receita_enviada

FROM agrocomum.empresa emp
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = emp.id_inscricaoestadual
         INNER JOIN agrocomum.classificacao AS c ON ie.id_classificacao = c.id_classificacao
         INNER JOIN agrocomum.classificacao_macro_composta AS cmc ON cmc.id_classificacaooriginal = c.id_classificacao AND cmc.id_classificacaomacro = 28
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS e ON iee.id_endereco = e.id_endereco
         INNER JOIN dne.log_localidade AS ll ON e.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON ll.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional
         INNER JOIN rh.pessoa AS pe ON pe.id = ie.id_pessoa
         INNER JOIN rh.documento AS d ON d.id_pessoa = pe.id AND id_documento_tipo = 2
         LEFT JOIN (SELECT tf.id_inscricaoestadual                 AS ie,
                           COUNT(DISTINCT tf.id_termofiscalizacao) AS quantidade,
                           MAX(tf.dt_criacaotermo)                 AS emissao
                    FROM fisc.termo_fiscalizacao AS tf
                             INNER JOIN fisc.termoobjetivo_fiscalizacao AS tro ON tf.id_termofiscalizacao = tro.id_termofiscalizacao
                             INNER JOIN fisc.programa_fiscalizacao AS pr ON tro.id_programafiscalizacao = pr.id_programafiscalizacao
                    WHERE pr.id_programafiscalizacao = 5
                      AND tf.ativo = true
                    GROUP BY ie) AS tf ON tf.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT COUNT(ie.id_inscricaoestadual) AS quantidade,
                           MAX(rc.dt_emissao)             AS emissao,
                           MAX(rc.dt_criacao)             AS envio,
                           ie.id_inscricaoestadual        AS ie
                    FROM agrotoxicos.receitas AS rc
                             INNER JOIN rh.documento AS d ON d.numero = rc.cnpj_comerciante
                             INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_pessoa = d.id_pessoa
                    GROUP BY ie.id_inscricaoestadual) AS receita ON receita.ie = ie.id_inscricaoestadual
ORDER BY ie.id_inscricaoestadual
