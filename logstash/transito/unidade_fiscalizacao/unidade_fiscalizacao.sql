SELECT unid.id_unidademovel                              AS id,
       case when unid.bo_ativo then 'Sim' else 'Não' end AS ativo,
       unid.id_unidademovel                              AS unidade_id,
       unid.no_unidademovel                              AS unidade_nome,
       CASE
           WHEN unid.bo_movel = true THEN 'Movel'
           WHEN unid.bo_movel = false THEN 'Fixo'
           END                                             AS unidade_tipo,

       COALESCE(unid.lat, 0)                             AS unidade_gps_latitude,
       COALESCE(unid.lon, 0)                             AS unidade_gps_longitude,
       COUNT(*)                                          AS fiscais_qtd,
       STRING_AGG(pf.nome, ',')                          AS fiscal_nome

FROM fisc.unidademovel AS unid
         INNER JOIN fisc.unidademovel_funcionario AS func ON unid.id_unidademovel = func.id_unidademovel
         INNER JOIN rh.pessoa AS pf ON func.id_pessoa = pf.id
GROUP BY unid.id_unidademovel, unid.bo_ativo, unid.no_unidademovel,unid.lat,unid.lon
ORDER BY unid.id_unidademovel
