SELECT ie.id_inscricaoestadual                                                                                AS id,
       ie.id_situacaocadastral                                                                                AS empresa_situacao_id,
       CASE
           WHEN ie.id_situacaocadastral = 5 THEN 'SUSPENSA'
           WHEN ie.id_situacaocadastral = 6 THEN 'DESCREDENCIADA'
           WHEN ie.id_situacaocadastral = 8 THEN 'ERRO CADASTRO'
           ELSE 'ATIVA'
           END                                                                                                  AS empresa_situacao_descricao,

       UPPER(ie.no_fantasia)                                                                                  AS empresa_nome,
       d.numero                                                                                               AS empresa_cnpj,
       c.ds_classificacao                                                                                     AS empresa_classificacao,
       ie.nu_inscricaoestadual                                                                                AS empresa_ie,
       COALESCE(ie.vl_latitude, 0)                                                                            AS empresa_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                                                           AS empresa_gps_longitude,
       llr.nome                                                                                               AS empresa_regional_nome,
       ll.loc_no                                                                                              AS empresa_municipio_nome,
       ll.ufe_sg                                                                                              AS empresa_municipio_uf,
       ll.cod_ibge                                                                                            AS empresa_municipio_ibge,
       COALESCE(ll.lat, 0)                                                                                    AS empresa_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                                                    AS empresa_municipio_gps_longitude,

       ie.dt_credenciamento                                                                                   AS empresa_credenciamento_data,
       CURRENT_DATE - ie.dt_credenciamento                                                                    AS empresa_credenciamento_dias,

       tf.emissao                                                                                             AS tf_emissao,
       COALESCE(tf.quantidade, 0)                                                                             AS tf_quantidade,
       CASE WHEN COALESCE(tf.quantidade, 0) > 0 THEN 'Sim' ELSE 'Não' end                                     AS tf_fiscalizado,
       extract(DAY FROM CURRENT_DATE - tf.emissao)                                                            AS tf_dia,
       ROUND((extract(DAY FROM CURRENT_DATE - tf.emissao) / 30)::NUMERIC, 0)                                  AS tf_mes,
       CASE WHEN COALESCE(extract(DAY FROM CURRENT_DATE - tf.emissao) / 30, 5) >= 5 THEN 'Sim' ELSE 'Não' end AS tf_insuficiente,

       receita.emissao                                                                                        AS receita_emissao,
       receita.envio                                                                                          AS receita_envio,
       COALESCE(receita.quantidade, 0)                                                                        AS receita_quantidade,
       COALESCE(receita.propriedade, 0)                                                                       AS receita_propriedade,
       COALESCE(receita.rt, 0)                                                                                AS receita_rt,
       COALESCE(receita.agrotoxico, 0)                                                                        AS receita_agrotoxico,
       COALESCE(receita.litro, 0)                                                                             AS receita_litro,
       CASE WHEN COALESCE(receita.quantidade, 0) > 0 THEN 'Sim' ELSE 'Não' end                                AS receita_enviada,

       COALESCE(fea_ur.total, 0)                                                                              AS fea_ur_total,
       COALESCE(fea_uol.total, 0)                                                                             AS fea_uol_total,
       CASE WHEN COALESCE(fea_uol.total, 0) > 0 THEN 'Sim' ELSE 'Não' end                                     AS fea_uol_presente

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
         LEFT JOIN (SELECT COUNT(DISTINCT rc.id_receita)                                AS quantidade,
                           MAX(rc.dt_emissao)                                           AS emissao,
                           MAX(rc.dt_criacao)                                           AS envio,
                           COUNT(DISTINCT rc.nu_inscricao_estadual)                     AS propriedade,
                           COUNT(DISTINCT rc.cpf_responsavel_tecnico)                   AS rt,
                           COUNT(DISTINCT i.produto)                                    AS agrotoxico,
                           SUM(REPLACE(TRIM(i.quantidade_adquirir), ',', '.')::NUMERIC) AS litro,
                           ie.id_inscricaoestadual                                      AS ie
                    FROM agrotoxicos.receitas AS rc
                             INNER JOIN agrotoxicos.itens_receita AS i ON i.id_receita = rc.id_receita
                             INNER JOIN rh.documento AS d ON d.numero = rc.cnpj_comerciante
                             INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_pessoa = d.id_pessoa
                    GROUP BY ie.id_inscricaoestadual) AS receita ON receita.ie = ie.id_inscricaoestadual
         LEFT JOIN (SELECT l.id        AS id,
                           count(p.id) AS total
                    FROM rh.funcionario AS f
                             JOIN rh.pessoa AS p ON f.id_pessoa = p.id
                             JOIN rh.cargo_funcionario AS cf ON cf.id_pessoa = p.id
                             JOIN rh.cargo AS c ON cf.id_cargo = c.id
                             JOIN rh.funcionario_titularidade AS pp ON pp.id_pessoa = p.id
                             JOIN rh.lotacao_funcionario AS lf ON f.id_pessoa = lf.id_pessoa
                             JOIN rh.lotacao AS l ON lf.id_lotacao = l.id
                             LEFT JOIN (SELECT DISTINCT p.id AS id
                                        FROM rh.pessoa AS p
                                                 INNER JOIN rh.bloqueio AS b ON b.id_pessoa = p.id
                                                 INNER JOIN rh.afastamento AS af ON af.id_bloqueio = b.id_bloqueio and b.dt_inicio <= current_date and b.dt_final >= current_date) AS afas ON afas.id = p.id
                    WHERE cf.id_cargo = 131
                      AND f.bo_ativo = true
                      AND pp.id_profissao = 5
                      AND afas.id is null
                      AND lf.dt_final is null
                      AND cf.dt_final is null
                      AND l.bo_ativo = true
                    GROUP BY l.id) AS fea_uol ON fea_uol.id = l.id

         LEFT JOIN (SELECT ll.id       AS id,
                           count(p.id) AS total
                    FROM rh.funcionario AS f
                             JOIN rh.pessoa AS p ON f.id_pessoa = p.id
                             JOIN rh.cargo_funcionario AS cf ON cf.id_pessoa = p.id
                             JOIN rh.cargo AS c ON cf.id_cargo = c.id
                             JOIN rh.funcionario_titularidade AS pp ON pp.id_pessoa = p.id
                             JOIN rh.lotacao_funcionario AS lf ON f.id_pessoa = lf.id_pessoa
                             JOIN rh.lotacao AS l ON lf.id_lotacao = l.id
                             JOIN rh.lotacao AS ll ON ll.id = l.id_lotacao_pai
                             LEFT JOIN (SELECT DISTINCT p.id AS id
                                        FROM rh.pessoa AS p
                                                 INNER JOIN rh.bloqueio AS b ON b.id_pessoa = p.id
                                                 INNER JOIN rh.afastamento AS af ON af.id_bloqueio = b.id_bloqueio and b.dt_inicio <= current_date and b.dt_final >= current_date) AS afas ON afas.id = p.id
                    WHERE cf.id_cargo = 131
                      AND f.bo_ativo = true
                      AND pp.id_profissao = 5
                      AND afas.id is null
                      AND lf.dt_final is null
                      AND cf.dt_final is null
                      AND l.bo_ativo = true
                      AND l.id not in (2357, 2512, 2529) --PF Ceasa - Goiânia, UOL CEASA - GOIÂNIA, UOL CEASA - ANÁPOLIS
                    GROUP BY ll.id) AS fea_ur ON fea_ur.id = llr.id

ORDER BY ie.id_inscricaoestadual
