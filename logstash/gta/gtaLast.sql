SELECT gt.id_gta                                   AS id,
       CAST(gt.nu_gta AS integer)                  AS numero,
       gt.nu_serie                                 AS serie,
       gt.ts_emissao                               AS emissao,
       gr.ids_boleto                               AS dare,
       CAST(gr.vl_gta AS numeric)                  AS valor,
       gt.bo_ativo                                 AS ativo,

       f.id_finalidade                             AS finalidade_id,
       f.no_finalidade                             AS finalidade_nome,

       es.id                                       AS especie_id,
       es.no_especie                               AS especie_nome,

       tt.id_tipotransporte                        AS transporte_id,
       tt.no_tipotransporte                        AS transporte_nome,

       pe.id                                       AS emissor_id,
       pe.nome                                     AS emissor_nome,
       lote.id                                     AS emissor_lotacao_id,
       lote.nome                                   AS emissor_lotacao_nome,
       reg.id                                      AS emissor_lotacao_regional_id,
       reg.nome                                    AS emissor_lotacao_regional_nome,

       ieo.id_inscricaoestadual                    AS origem_propriedade_id,
       pro.nu_codigoanimal                         AS origem_propriedade_codigo,
       ieo.no_fantasia                             AS origem_propriedade_nome_fantasia,
       ieo.nu_inscricaoestadual                    AS origem_propriedade_ie,
       po.id                                       AS origem_propriedade_proprietario_id,
       po.nome                                     AS origem_propriedade_proprietario_nome,
       dco.numero                                  AS origem_propriedade_proprietario_documento,
       lo.loc_nu                                   AS origem_propriedade_municipio_id,
       lo.loc_no                                   AS origem_propriedade_municipio_nome,
       lo.ufe_sg                                   AS origem_propriedade_municipio_uf,
       COALESCE(lo.lat, 0)                         AS origem_propriedade_municipio_localizacao_latitude,
       COALESCE(lo.lon, 0)                         AS origem_propriedade_municipio_localizacao_longitude,

       ied.id_inscricaoestadual                    AS destino_propriedade_id,
       prd.nu_codigoanimal                         AS destino_propriedade_codigo,
       ied.no_fantasia                             AS destino_propriedade_nome_fantasia,
       ied.nu_inscricaoestadual                    AS destino_propriedade_ie,
       pd.id                                       AS destino_propriedade_proprietario_id,
       pd.nome                                     AS destino_propriedade_proprietario_nome,
       dcd.numero                                  AS destino_propriedade_proprietario_documento,
       ld.loc_nu                                   AS destino_propriedade_municipio_id,
       ld.ufe_sg                                   AS destino_propriedade_municipio_uf,
       ld.loc_no                                   AS destino_propriedade_municipio_nome,
       COALESCE(ld.lat, 0)                         AS destino_propriedade_municipio_localizacao_latitude,
       COALESCE(ld.lon, 0)                         AS destino_propriedade_municipio_localizacao_longitude,

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
          AND em.tp_sexo = 'IN')                   AS estratificacao_indeterminado
FROM gta.gta AS gt
            INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta
            INNER JOIN gta.gta_destino AS gtd ON gt.id_gta = gtd.id_gta
            INNER JOIN gta.finalidade AS f ON gt.id_finalidade = f.id_finalidade
            INNER JOIN gta.tipo_transporte AS tt ON gt.id_tipotransporte = tt.id_tipotransporte
            LEFT JOIN agrocomum.inscricaoestadual AS ieo ON gto.id_origem = ieo.id_inscricaoestadual
            LEFT JOIN agrocomum.inscricaoestadual AS ied ON gtd.id_destino = ied.id_inscricaoestadual
            LEFT JOIN agrocomum.propriedade AS pro ON ieo.id_inscricaoestadual = pro.id_inscricaoestadual
            LEFT JOIN agrocomum.propriedade AS prd ON ied.id_inscricaoestadual = prd.id_inscricaoestadual
            LEFT JOIN rh.documento AS dco ON ieo.id_pessoa = dco.id_pessoa and dco.id_documento_tipo in (1, 2)
            LEFT JOIN rh.documento AS dcd ON ied.id_pessoa = dcd.id_pessoa and dcd.id_documento_tipo in (1, 2)
            LEFT JOIN rh.pessoa AS po ON ieo.id_pessoa = po.id
            LEFT JOIN rh.pessoa AS pd ON ied.id_pessoa = pd.id
            INNER JOIN dne.log_localidade AS lo ON gto.id_municipio = lo.loc_nu
            INNER JOIN dne.log_localidade AS ld ON gtd.id_municipio = ld.loc_nu
            INNER JOIN rh.pessoa AS pe ON gt.id_emissor = pe.id
            INNER JOIN dsa.especie AS es ON gt.id_especie = es.id
            INNER JOIN gta.gta_rascunho AS gr ON gt.id_gta_rascunho = gr.id_gta_rascunho
            INNER JOIN rh.lotacao AS lote ON gt.id_lotacao_emissor = lote.id
            INNER JOIN rh.lotacao AS reg ON lote.id_lotacao_pai = reg.id
WHERE gt.id_gta > :sql_last_value
ORDER BY gt.id_gta ASC