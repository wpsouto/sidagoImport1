SELECT i.id_item                                                     AS id,
       rc.id_receita                                                 AS receita_id,
       rc.nu_receita                                                 AS numero,
       rc.dt_emissao                                                 AS emissao,
       rc.dt_criacao                                                 AS envio,
       ct.ds_nome                                                    AS cultura,
       rc.ts_alteracao                                               AS ts_alteracao,
       case when rc.situacao_externa = 'C' then 'Sim' else 'Não' end AS cancelada,

       rc.no_produtor                                                AS produtor_nome,
       rc.documento_produtor                                         AS produtor_documento,

       pd.id_inscricaoestadual                                       AS propriedade_id,
       UPPER(pd.no_fantasia)                                         AS propriedade_nome,
       pd.nu_inscricaoestadual                                       AS propriedade_ie,
       pai.nome                                                      AS propriedade_regional_nome,
       lc.loc_no                                                     AS propriedade_municipio_nome,
       lc.ufe_sg                                                     AS propriedade_municipio_uf,
       lc.cod_ibge                                                   AS propriedade_municipio_ibge,
       COALESCE(lc.lat, 0)                                           AS propriedade_municipio_localizacao_latitude,
       COALESCE(lc.lon, 0)                                           AS propriedade_municipio_localizacao_longitude,

       UPPER(TRIM(rc.no_responsavel_tecnico))                        AS emissor_nome,
       rc.cpf_responsavel_tecnico                                    AS emissor_documento,

       UPPER(TRIM(rc.nome_comerciante))                              AS comerciante_nome,
       rc.cnpj_comerciante                                           AS comerciante_documento,
       ll.loc_no                                                     AS comerciante_municipio_nome,
       ll.ufe_sg                                                     AS comerciante_municipio_uf,
       ll.cod_ibge                                                   AS comerciante_municipio_ibge,
       COALESCE(ll.lat, 0)                                           AS comerciante_municipio_localizacao_latitude,
       COALESCE(ll.lon, 0)                                           AS comerciante_municipio_localizacao_longitude,

       UPPER(ie_t.no_fantasia)                                       AS empresa_software_nome,

       ag.ds_registro                                                AS agrotoxico_registro,
       ag.ds_nome                                                    AS agrotoxico_nome,
       REPLACE(TRIM(i.quantidade_adquirir), ',', '.')
       ::NUMERIC AS agrotoxico_quantidade,

       CASE
           WHEN i.unidade_medida_adquirir = 'Ds' THEN 'Dose'
           WHEN i.unidade_medida_adquirir = 'L' THEN 'Litro'
           WHEN i.unidade_medida_adquirir = 'Un' THEN 'Unidade'
           WHEN i.unidade_medida_adquirir = 'Amp' THEN 'Ampola'
           WHEN i.unidade_medida_adquirir = 'Tn' THEN 'Tonelada'
           WHEN i.unidade_medida_adquirir = 'Kg' THEN 'Kilo'
           WHEN i.unidade_medida_adquirir = 'Dz' THEN 'Dúzia'
           WHEN i.unidade_medida_adquirir = 'Ha' THEN 'Hectare'
           ELSE i.unidade_medida_adquirir
           END                                                       AS agrotoxico_unidade,

       COALESCE(i.area_aplicacao, 0)                                 AS agrotoxico_area,
       i.diagnostico                                                 AS agrotoxico_eppo,
       praga.nome                                                    AS agrotoxico_praga,
       i.tipo_aplicacao                                              as agrotoxico_aplicacao

FROM agrotoxicos.receitas AS rc
         INNER JOIN agrotoxicos.itens_receita AS i ON i.id_receita = rc.id_receita
         INNER JOIN agrotoxicos.agrotoxico AS a ON i.produto = a.nu_registromapa
         INNER JOIN produtos.produto AS ag ON a.id_produto = ag.id_produto
         INNER JOIN produtos.produto AS ct ON rc.cod_cultura = ct.id_produto::text
         LEFT JOIN agrocomum.inscricaoestadual AS pd ON pd.nu_inscricaoestadual = rc.nu_inscricao_estadual
         LEFT JOIN agrocomum.inscricaoestadual_endereco AS ied ON pd.id_inscricaoestadual = ied.id_inscricaoestadual
         LEFT JOIN agrocomum.endereco AS en ON ied.id_endereco = en.id_endereco
         LEFT JOIN dne.log_localidade AS lc ON en.id_localidade = lc.loc_nu
         LEFT JOIN rh.lotacao AS l ON l.id_localidade = lc.loc_nu AND l.bo_ativo = true AND id_lotacaotipo = 3 AND l.bo_organograma = true
         LEFT JOIN rh.lotacao AS pai ON pai.id = l.id_lotacao_pai AND pai.id_lotacaotipo = 2 AND pai.bo_ativo = true AND pai.bo_organograma = true
         INNER JOIN rh.usuario AS us_t ON us_t.usuario = rc.usuario
         INNER JOIN agrocomum.inscricaoestadual ie_t ON ie_t.id_pessoa = us_t.id_pessoa
         LEFT JOIN rh.documento d ON d.numero = rc.cnpj_comerciante
         LEFT JOIN agrocomum.inscricaoestadual com ON com.id_pessoa = d.id_pessoa AND com.id_classificacao IN (128, 129)
         LEFT JOIN agrocomum.inscricaoestadual_endereco AS iee ON com.id_inscricaoestadual = iee.id_inscricaoestadual
         LEFT JOIN agrocomum.endereco AS e ON iee.id_endereco = e.id_endereco
         LEFT JOIN dne.log_localidade AS ll ON e.id_localidade = ll.loc_nu
         INNER JOIN (SELECT pr.eppo_code                  AS eppo_code,
                            string_agg(pr.no_praga, ', ') AS nome
                     FROM gtv.praga AS pr
                     GROUP BY pr.eppo_code) AS praga ON praga.eppo_code = i.diagnostico
WHERE rc.ts_alteracao > :sql_last_value
ORDER BY i.id_item
