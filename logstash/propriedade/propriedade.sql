SELECT ie.id_inscricaoestadual "id",
       ie.nu_inscricaoestadual "numero",
       ie.no_fantasia "nome_fantasia",
       ie.vl_latitude,
       ie.vl_longitude,
       -(cast(SUBSTRING(cast(ie.vl_latitude as text),1,2) as NUMERIC) + (cast(SUBSTRING(cast(ie.vl_latitude as text),3,2) as NUMERIC) / 60) + ((cast(SUBSTRING(cast(ie.vl_latitude as text),5) as NUMERIC)/10) / 3600)) "latitude",
       -(cast(SUBSTRING(cast(ie.vl_longitude as text),1,2) as NUMERIC) + (cast(SUBSTRING(cast(ie.vl_longitude as text),3,2) as NUMERIC) / 60) + ((cast(SUBSTRING(cast(ie.vl_longitude as text),5) as NUMERIC)/10) / 3600)) "longitude",
       ie.ts_inscricaoestadual "dt_atualizacao",
       pr.nu_codigoanimal "codigo_animal",
       pr.nu_codigovegetal "codigo_vegetal",
       p.id "pessoa_id",
       p.nome "pessoa_nome",
       d.numero "pessoa_numero"
FROM agrocomum.inscricaoestadual ie
    JOIN agrocomum.propriedade pr ON ie.id_inscricaoestadual = pr.id_inscricaoestadual
    JOIN rh.pessoa p ON p.id = ie.id_pessoa
    JOIN rh.documento d ON p.id = d.id_pessoa
    JOIN rh.documento_tipo dt ON d.id_documento_tipo = dt.id_documentotipo
WHERE dt.no_documentotipo IN ('CNPJ', 'CPF')
--  AND ie.ts_inscricaoestadual > :sql_last_value
  AND ie.vl_latitude  > 100000
  AND ie.vl_longitude > 100000
ORDER BY p.id
