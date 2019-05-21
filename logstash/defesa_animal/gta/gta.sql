SELECT gt.id_gta                                   AS id,
       CAST(gt.nu_gta AS integer)                  AS numero,
       gt.nu_serie                                 AS serie,
       gt.ts_emissao                               AS emissao,
       trim(dados->>'id_boleto')                   AS dare,
       CAST(dados->>'vl_gta' AS numeric)           AS valor,
       case when gt.bo_ativo = TRUE then 'Não' else 'Sim' end        AS cancelada,
       case when reg.bo_organograma = TRUE then 'Sim' else 'Não' end AS organograma,
       gt.ts_alteracao                             AS ts_alteracao,

       f.id_finalidade                             AS finalidade_id,
       f.no_finalidade                             AS finalidade_nome,

       es.id                                       AS especie_id,
       es.no_especie                               AS especie_nome,

       dados->>'transporte'                        AS transporte_nome,

       dados->>'nome_emissor'                      AS emissor_nome,
       dados->>'documento_emissor'                 AS emissor_documento,
       lote.id                                     AS emissor_lotacao_id,
       lote.nome                                   AS emissor_lotacao_nome,
       reg.id                                      AS emissor_lotacao_regional_id,
       reg.nome                                    AS emissor_lotacao_regional_nome,

       gto.tp_origem                               AS origem_tipo,
       dados->'origem'->>'codigo_estabelecimento'  AS origem_estabelecimento_codigo,
       dados->'origem'->>'nome_fantasia'           AS origem_estabelecimento_nome_fantasia,
       dados->'origem'->>'razao_social'            AS origem_estabelecimento_razao_social,
       dados->'origem'->>'inscricao_estadual'      AS origem_estabelecimento_ie,
       dados->'origem'->>'documento'               AS origem_estabelecimento_proprietario_documento,
       lo.loc_no                                   AS origem_municipio_nome,
       lo.ufe_sg                                   AS origem_municipio_uf,
       COALESCE(lo.lat,0)                          AS origem_municipio_localizacao_latitude,
       COALESCE(lo.lon,0)                          AS origem_municipio_localizacao_longitude,

       gtd.tp_destino                              AS destino_tipo,
       dados->'destino'->>'codigo_estabelecimento' AS destino_estabelecimento_codigo,
       dados->'destino'->>'nome_fantasia'          AS destino_estabelecimento_nome_fantasia,
       dados->'destino'->>'razao_social'           AS destino_estabelecimento_razao_social,
       dados->'destino'->>'inscricao_estadual'     AS destino_estabelecimento_ie,
       dados->'destino'->>'documento'              AS destino_estabelecimento_proprietario_documento,
       ld.loc_no                                   AS destino_municipio_nome,
       ld.ufe_sg                                   AS destino_municipio_uf,
       COALESCE(ld.lat,0)                          AS destino_municipio_localizacao_latitude,
       COALESCE(ld.lon,0)                          AS destino_municipio_localizacao_longitude,

       (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
        FROM gta.estratificacao_gta AS gem
        INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
        WHERE gem.id_gta = gt.id_gta
        AND em.tp_sexo = 'FE')                   AS estratificacao_femea,
       (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
        FROM gta.estratificacao_gta AS gem
        INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
        WHERE gem.id_gta = gt.id_gta
        AND em.tp_sexo = 'MA')                   AS estratificacao_macho,
       (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
        FROM gta.estratificacao_gta AS gem
        INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
        WHERE gem.id_gta = gt.id_gta
        AND em.tp_sexo = 'IN')                   AS estratificacao_indefinido,
       (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
        FROM gta.estratificacao_gta AS gem
        INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
        WHERE gem.id_gta = gt.id_gta)            AS estratificacao_total

FROM gta.gta as gt
    INNER JOIN gta.finalidade AS f ON gt.id_finalidade = f.id_finalidade
    INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
    INNER JOIN rh.lotacao AS lote ON gt.id_lotacao_emissor = lote.id
    INNER JOIN rh.lotacao AS reg ON lote.id_lotacao_pai = reg.id
    INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta
    INNER JOIN gta.gta_destino AS gtd ON gt.id_gta = gtd.id_gta
    INNER JOIN dne.log_localidade AS lo ON gto.id_municipio = lo.loc_nu
    INNER JOIN dne.log_localidade AS ld ON gtd.id_municipio = ld.loc_nu
WHERE gt.ts_alteracao > :sql_last_value
ORDER BY gt.id_gta ASC
