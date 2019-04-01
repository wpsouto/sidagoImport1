SELECT  gt.id_gta                                   AS id_gta,
        gt.nu_gta                                   AS nu_gta,
        gt.nu_serie                                 AS nu_serie,
        gt.ts_emissao                               AS ts_emissao,
        dados->>'data_validade'                     AS dt_validade,
        dados->>'vl_gta'                            AS vl_gta,
        dados->>'finalidade'                        AS finalidade,
        es.no_especie                               AS no_especie,
        trim(dados->>'id_boleto')                   AS dare,
        dados->>'transporte'                        AS transporte,
        gt.bo_ativo                                 AS bo_ativo,
        dados->>'documento_emissor'                 AS emissor_documento,
        dados->>'nome_emissor'                      AS emissor_nome,
        dados->>'nome_lotacao_emissor'              AS emissor_lotacao,
        dados->'origem'->>'documento'               AS origem_documento,
        dados->'origem'->>'razao_social'            AS origem_razao_social,
        dados->'origem'->>'nome_fantasia'           AS origem_nome_fantasia,
        dados->'origem'->>'municipio_uf'            AS origem_municipio_uf,
        dados->'origem'->>'inscricao_estadual'      AS origem_inscricao_estadual,
        dados->'origem'->>'codigo_estabelecimento'  AS origem_codigo_estabelecimento,
        dados->'destino'->>'documento'              AS destino_documento,
        dados->'destino'->>'razao_social'           AS destino_razao_social,
        dados->'destino'->>'nome_fantasia'          AS destino_nome_fantasia,
        dados->'destino'->>'municipio_uf'           AS destino_municipio_uf,
        dados->'destino'->>'inscricao_estadual'     AS destino_inscricao_estadual,
        dados->'destino'->>'codigo_estabelecimento' AS destino_codigo_estabelecimento,

        (SELECT COALESCE(SUM(gem.nu_quantidade), 0) FROM gta.estratificacao_gta AS gem INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id WHERE gem.id_gta = gt.id_gta AND em.tp_sexo = 'FE') AS estratificacoes_femea,
        (SELECT COALESCE(SUM(gem.nu_quantidade), 0) FROM gta.estratificacao_gta AS gem INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id WHERE gem.id_gta = gt.id_gta AND em.tp_sexo = 'MA') AS estratificacoes_macho

FROM gta.gta as gt
     INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
WHERE gt.id_gta > :sql_last_value
ORDER  BY gt.id_gta ASC