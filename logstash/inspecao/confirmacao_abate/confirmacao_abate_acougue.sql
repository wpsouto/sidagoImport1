SELECT gt.id_gta                                                               AS id,
       ca.ts_confirmacaoabatelote                                              AS confirmacao,
       CASE WHEN ca.id_confirmacaoabatelote is null THEN 'Não' ELSE 'Sim' END  AS confirmada,
       CASE WHEN ca.bo_ativo = false THEN 'Sim' ELSE 'Não' END                 AS cancelada,

       CASE
           WHEN bo_foraprazo = true THEN 'Fora do Prazo'
           WHEN bo_foraprazo = false THEN 'Dentro do Prazo'
           END                                                                 AS tipo,

       p.id                                                                    AS fiscal_id,
       UPPER(p.nome)                                                           AS fiscal_nome,
       dor.numero                                                              AS fiscal_documento,
       gt.id_gta                                                               AS gta_id,
       CASE WHEN gt.bo_ativo = TRUE THEN 'Não' ELSE 'Sim' END                  AS gta_cancelada,
       CAST(gt.nu_gta AS integer)                                              AS gta_numero,
       gt.nu_serie                                                             AS gta_serie,
       gt.ts_emissao                                                           AS gta_emissao,

       es.id                                                                   AS especie_id,
       es.no_especie                                                           AS especie_nome,

       gto.tp_origem                                                           AS origem_tipo,
       dados -> 'origem' ->> 'codigo_estabelecimento'                          AS origem_estabelecimento_codigo,
       UPPER(dados -> 'origem' ->> 'nome_fantasia')                            AS origem_estabelecimento_nome_fantasia,
       UPPER(dados -> 'origem' ->> 'razao_social')                             AS origem_estabelecimento_razao_social,
       dados -> 'origem' ->> 'inscricao_estadual'                              AS origem_estabelecimento_ie,
       dados -> 'origem' ->> 'documento'                                       AS origem_estabelecimento_proprietario_documento,
       lo.loc_no                                                               AS origem_municipio_nome,
       lo.ufe_sg                                                               AS origem_municipio_uf,
       COALESCE(lo.lat, 0)                                                     AS origem_municipio_gps_latitude,
       COALESCE(lo.lon, 0)                                                     AS origem_municipio_gps_longitude,

       gtd.tp_destino                                                          AS destino_tipo,
       dados -> 'destino' ->> 'codigo_estabelecimento'                         AS destino_estabelecimento_codigo,
       UPPER(dados -> 'destino' ->> 'nome_fantasia')                           AS destino_estabelecimento_nome_fantasia,
       UPPER(dados -> 'destino' ->> 'razao_social')                            AS destino_estabelecimento_razao_social,
       dados -> 'destino' ->> 'inscricao_estadual'                             AS destino_estabelecimento_ie,
       dados -> 'destino' ->> 'documento'                                      AS destino_estabelecimento_proprietario_documento,
       ld.loc_no                                                               AS destino_municipio_nome,
       ld.ufe_sg                                                               AS destino_municipio_uf,
       COALESCE(ld.lat, 0)                                                     AS destino_municipio_gps_latitude,
       COALESCE(ld.lon, 0)                                                     AS destino_municipio_gps_longitude,

    (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
       FROM
       gta.estratificacao_gta AS gem
       INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
       WHERE
       gem.id_gta = gt.id_gta
       AND em.tp_sexo = 'FE')                                        AS estratificacao_femea,
    (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
       FROM
       gta.estratificacao_gta AS gem
       INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
       WHERE
       gem.id_gta = gt.id_gta
       AND em.tp_sexo = 'MA')                                        AS estratificacao_macho,
    (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
       FROM
       gta.estratificacao_gta AS gem
       INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
       WHERE
       gem.id_gta = gt.id_gta
       AND em.tp_sexo = 'IN')                                        AS estratificacao_indefinido,
    (SELECT COALESCE(SUM(gem.nu_quantidade), 0)
       FROM
       gta.estratificacao_gta AS gem
       WHERE
       gem.id_gta = gt.id_gta)                                       AS estratificacao_total,

    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_abatidos_lote AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'FE')                                        AS abatido_femea,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_abatidos_lote AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'MA')                                        AS abatido_macho,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_abatidos_lote AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'IN')                                        AS abatido_indefinido,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_abatidos_lote AS caa
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote) AS abatido_total,

    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_mortos AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'FE')                                        AS morte_femea,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_mortos AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'MA')                                        AS morte_macho,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_mortos AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'IN')                                        AS morte_indefinido,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_mortos AS caa
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote) AS morte_total,

    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_recusados AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'FE')                                        AS recusado_femea,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_recusados AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'MA')                                        AS recusado_macho,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_recusados AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'IN')                                        AS recusado_indefinido,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_recusados AS caa
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote) AS recusado_total,

    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_naochegou AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'FE')                                        AS naochegou_femea,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_naochegou AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'MA')                                        AS naochegou_macho,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_naochegou AS caa
       INNER JOIN dsa.estratificacao AS es ON caa.id_estratificacao = es.id
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote
       AND es.tp_sexo = 'IN')                                        AS naochegou_indefinido,
    (SELECT COALESCE(SUM(nu_animais), 0)
       FROM
       inspecao.confirmacao_abate_naochegou AS caa
       WHERE
       caa.id_gta = gt.id_gta
       AND caa.id_confirmacaoabatelote = ca.id_confirmacaoabatelote) AS naochegou_total

FROM   gta.gta AS gt
       INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
       INNER JOIN gta.gta_destino AS gtd ON gt.id_gta = gtd.id_gta AND gtd.tp_destino = 'acougue_carneos'
       INNER JOIN agrocomum.inscricaoestadual AS ied ON ied.id_inscricaoestadual = gtd.id_destinovinculado
       INNER JOIN agrocomum.classificacao AS cl ON cl.id_classificacao = ied.id_classificacao
       INNER JOIN agrocomum.classificacao_macro_composta AS cmc ON cmc.id_classificacaooriginal = cl.id_classificacao AND cmc.id_classificacaomacro = 1
       INNER JOIN dne.log_localidade AS ld ON gtd.id_municipiovinculado = ld.loc_nu AND ld.ufe_sg = 'GO'
       INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta
       INNER JOIN dne.log_localidade AS lo ON gto.id_municipio = lo.loc_nu
       LEFT JOIN inspecao.confirmacao_abate_lote_gta AS cag ON cag.id_gta = gt.id_gta
       LEFT JOIN inspecao.confirmacao_abate_lote AS ca ON ca.id_confirmacaoabatelote = cag.id_confirmacaoabatelote
       LEFT JOIN rh.pessoa AS p ON ca.id_responsavel = p.id
       LEFT JOIN rh.documento AS dor ON p.id = dor.id_pessoa AND dor.id_documento_tipo IN (1)
WHERE gt.ts_emissao::date >= current_date - interval '1 month'
ORDER BY gt.id_gta
