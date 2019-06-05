SELECT ie.id_inscricaoestadual                                                                                            AS id,
       ie.id_inscricaoestadual || '_' || EXTRACT(epoch from DATE_TRUNC('month', current_date - interval '1 month')::DATE) AS id_mes,
       CASE
           WHEN ie.id_situacaocadastral = 6 THEN 'Não'
           WHEN ie.id_situacaocadastral = 8 THEN 'Não'
           ELSE
               'Sim'
           END                                                                                                              AS empresa_ativa,

       CASE
           WHEN c.tp_identificacao = 'industrial' THEN 'Industrial'
           WHEN c.tp_identificacao = 'comercial' THEN 'Comercial'
           END                                                                                                              AS empresa_identificacao,

       UPPER(ie.no_fantasia)                                                                                              AS empresa_nome,
       c.ds_classificacao                                                                                                 AS empresa_classificacao,
       case when COALESCE(tf.tf_quantidade, 0) > 0 then 'Sim' else 'Não' end                                              AS empresa_fiscalizada,
       ie.nu_inscricaoestadual                                                                                            AS empresa_ie,
       COALESCE(ie.vl_latitude, 0)                                                                                        AS empresa_localizacao_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                                                                       AS empresa_localizacao_gps_longitude,
       llr.nome                                                                                                           AS empresa_regional_nome,
       ll.loc_no                                                                                                          AS empresa_municipio_nome,
       ll.ufe_sg                                                                                                          AS empresa_municipio_uf,
       COALESCE(ll.lat, 0)                                                                                                AS empresa_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                                                                AS empresa_municipio_gps_longitude,

       UPPER(p.nome)                                                                                                      AS proprietario_nome,
       d.numero                                                                                                           AS proprietario_documento,
       COALESCE(tf.tf_quantidade, 0)                                                                                      AS termo_fiscalizacao_quantidade,
       DATE_TRUNC('month', current_date - interval '1 month')::DATE                                                       AS termo_fiscalizacao_emissao

FROM agrocomum.empresa emp
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = emp.id_inscricaoestadual
         INNER JOIN agrocomum.classificacao AS c ON ie.id_classificacao = c.id_classificacao
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS e ON iee.id_endereco = e.id_endereco
         INNER JOIN dne.log_localidade AS ll ON e.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON ll.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN rh.documento AS d ON ie.id_pessoa = d.id_pessoa AND d.id_documento_tipo IN (1, 2)
         LEFT JOIN (SELECT tf.id_inscricaoestadual        AS tf_ie,
                           count(tf.id_termofiscalizacao) AS tf_quantidade
                    FROM fisc.termo_fiscalizacao AS tf
                    WHERE tf.ativo = true
                      AND tf.no_entidade = 'empresa'
                      AND DATE_TRUNC('month', dt_criacaotermo)::DATE = DATE_TRUNC('month', current_date - interval '1 month')::DATE
                    GROUP BY tf_ie) AS tf ON tf.tf_ie = ie.id_inscricaoestadual

WHERE c.tp_identificacao IN ('industrial', 'comercial')

UNION ALL

SELECT ie.id_inscricaoestadual                                                                                            AS id,
       ie.id_inscricaoestadual || '_' || EXTRACT(epoch from DATE_TRUNC('month', current_date - interval '0 month')::DATE) AS id_mes,
       CASE
           WHEN ie.id_situacaocadastral = 6 THEN 'Não'
           WHEN ie.id_situacaocadastral = 8 THEN 'Não'
           ELSE
               'Sim'
           END                                                                                                              AS empresa_ativa,

       CASE
           WHEN c.tp_identificacao = 'industrial' THEN 'Industrial'
           WHEN c.tp_identificacao = 'comercial' THEN 'Comercial'
           END                                                                                                              AS empresa_identificacao,

       UPPER(ie.no_fantasia)                                                                                              AS empresa_nome,
       c.ds_classificacao                                                                                                 AS empresa_classificacao,
       case when COALESCE(tf.tf_quantidade, 0) > 0 then 'Sim' else 'Não' end                                              AS empresa_fiscalizada,
       ie.nu_inscricaoestadual                                                                                            AS empresa_ie,
       COALESCE(ie.vl_latitude, 0)                                                                                        AS empresa_localizacao_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                                                                       AS empresa_localizacao_gps_longitude,
       llr.nome                                                                                                           AS empresa_regional_nome,
       ll.loc_no                                                                                                          AS empresa_municipio_nome,
       ll.ufe_sg                                                                                                          AS empresa_municipio_uf,
       COALESCE(ll.lat, 0)                                                                                                AS empresa_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                                                                AS empresa_municipio_gps_longitude,

       UPPER(p.nome)                                                                                                      AS proprietario_nome,
       d.numero                                                                                                           AS proprietario_documento,
       COALESCE(tf.tf_quantidade, 0)                                                                                      AS termo_fiscalizacao_quantidade,
       DATE_TRUNC('month', current_date - interval '0 month')::DATE                                                       AS termo_fiscalizacao_emissao

FROM agrocomum.empresa emp
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = emp.id_inscricaoestadual
         INNER JOIN agrocomum.classificacao AS c ON ie.id_classificacao = c.id_classificacao
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS e ON iee.id_endereco = e.id_endereco
         INNER JOIN dne.log_localidade AS ll ON e.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON ll.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN rh.documento AS d ON ie.id_pessoa = d.id_pessoa AND d.id_documento_tipo IN (1, 2)
         LEFT JOIN (SELECT tf.id_inscricaoestadual        AS tf_ie,
                           count(tf.id_termofiscalizacao) AS tf_quantidade
                    FROM fisc.termo_fiscalizacao AS tf
                    WHERE tf.ativo = true
                      AND tf.no_entidade = 'empresa'
                      AND DATE_TRUNC('month', dt_criacaotermo)::DATE = DATE_TRUNC('month', current_date - interval '0 month')::DATE
                    GROUP BY tf_ie) AS tf ON tf.tf_ie = ie.id_inscricaoestadual

WHERE c.tp_identificacao IN ('industrial', 'comercial')
ORDER BY id
