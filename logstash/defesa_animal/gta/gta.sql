SELECT gem.id_estratificacaogta                                          AS id,
       gt.id_gta                                                         AS id_gta,
       CAST(gt.nu_gta AS integer)                                        AS numero,
       gt.nu_serie                                                       AS serie,
       gt.ts_emissao                                                     AS emissao,
       trim(dados ->> 'id_boleto')                                       AS dare,
       CAST(dados ->> 'vl_gta' AS numeric)                               AS valor,
       case when gt.bo_ativo = TRUE then 'Não' else 'Sim' end            AS cancelada,
       case when reg.bo_organograma = TRUE then 'Sim' else 'Não' end     AS organograma,
       gt.ts_alteracao                                                   AS ts_alteracao,

       f.id_finalidade                                                   AS finalidade_id,
       f.no_finalidade                                                   AS finalidade_nome,

       g.id                                                              AS grupo_id,
       g.no_grupo                                                        AS grupo_nome,

       es.id                                                             AS especie_id,
       es.no_especie                                                     AS especie_nome,

       dados ->> 'transporte'                                            AS transporte_nome,

       case when reg.id = 2570 then lote.nome else 'Unidade Reginal' end AS emissor_tipo,
       UPPER(dados ->> 'nome_emissor')                                   AS emissor_nome,
       dados ->> 'documento_emissor'                                     AS emissor_documento,
       lote.id                                                           AS emissor_lotacao_id,
       lote.nome                                                         AS emissor_lotacao_nome,
       reg.id                                                            AS emissor_lotacao_regional_id,
       reg.nome                                                          AS emissor_lotacao_regional_nome,

       gto.id_gtaorigem                                                  AS origem_id,
       gto.tp_origem                                                     AS origem_tipo,
       gto.tp_origem || '_' || gto.id_origem                             AS origem_chave,
       dados -> 'origem' ->> 'codigo_estabelecimento'                    AS origem_estabelecimento_codigo,
       UPPER(dados -> 'origem' ->> 'nome_fantasia')                      AS origem_estabelecimento_nome_fantasia,
       UPPER(dados -> 'origem' ->> 'razao_social')                       AS origem_estabelecimento_razao_social,
       dados -> 'origem' ->> 'inscricao_estadual'                        AS origem_estabelecimento_ie,
       dados -> 'origem' ->> 'documento'                                 AS origem_estabelecimento_proprietario_documento,
       lo.loc_no                                                         AS origem_municipio_nome,
       lo.ufe_sg                                                         AS origem_municipio_uf,
       lo.cod_ibge                                                       AS origem_municipio_ibge,
       COALESCE(lo.lat, 0)                                               AS origem_municipio_localizacao_latitude,
       COALESCE(lo.lon, 0)                                               AS origem_municipio_localizacao_longitude,

       gtd.id_gtadestino                                                 AS destino_id,
       gtd.tp_destino                                                    AS destino_tipo,
       gtd.tp_destino || '_' || gtd.id_destino                           AS destino_chave,
       dados -> 'destino' ->> 'codigo_estabelecimento'                   AS destino_estabelecimento_codigo,
       UPPER(dados -> 'destino' ->> 'nome_fantasia')                     AS destino_estabelecimento_nome_fantasia,
       UPPER(dados -> 'destino' ->> 'razao_social')                      AS destino_estabelecimento_razao_social,
       dados -> 'destino' ->> 'inscricao_estadual'                       AS destino_estabelecimento_ie,
       dados -> 'destino' ->> 'documento'                                AS destino_estabelecimento_proprietario_documento,
       ld.loc_no                                                         AS destino_municipio_nome,
       ld.ufe_sg                                                         AS destino_municipio_uf,
       ld.cod_ibge                                                       AS destino_municipio_ibge,
       COALESCE(ld.lat, 0)                                               AS destino_municipio_localizacao_latitude,
       COALESCE(ld.lon, 0)                                               AS destino_municipio_localizacao_longitude,

       em.tp_sexo                                                        AS estratificacao_sexo,
       em.nome                                                           AS estratificacao_nome,
       em.sigla                                                          AS estratificacao_sigla,
       em.nu_ordem                                                       AS estratificacao_ordem,
       COALESCE(gem.nu_quantidade, 0)                                    AS estratificacao_quantidade,
       CAST(dados ->> 'vl_gta' AS numeric) / estratificacao.registros    AS estratificacao_valor
FROM gta.gta as gt
         INNER JOIN gta.finalidade AS f ON gt.id_finalidade = f.id_finalidade
         INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
         INNER JOIN dsa.grupo AS g ON es.id_grupo = g.id
         INNER JOIN rh.lotacao AS lote ON gt.id_lotacao_emissor = lote.id
         INNER JOIN rh.lotacao AS reg ON lote.id_lotacao_pai = reg.id
         INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta
         INNER JOIN gta.gta_destino AS gtd ON gt.id_gta = gtd.id_gta
         INNER JOIN dne.log_localidade AS lo ON gto.id_municipio = lo.loc_nu
         INNER JOIN dne.log_localidade AS ld ON gtd.id_municipio = ld.loc_nu
         INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
         INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id
         INNER JOIN (SELECT gt.id_gta        AS id,
                            count(gt.id_gta) AS registros
                     FROM gta.gta as gt
                              INNER JOIN gta.estratificacao_gta AS gem ON gem.id_gta = gt.id_gta
                     GROUP BY gt.id_gta) AS estratificacao ON estratificacao.id = gt.id_gta
WHERE gt.ts_alteracao > DATE_TRUNC('minute', TIMESTAMP :sql_last_value - interval '3 hour')
ORDER BY gt.id_gta ASC
