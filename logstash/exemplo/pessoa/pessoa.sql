SELECT p.id "id",
       p.nome "nome",
       p.fisica "fisica",
       p.sexo "sexo",
       p.bo_produtorrural "produtor",
       p.email "email",
       p.ts_pessoa "dt_atualizacao",
       d.id "documento_id",
       d.numero "documento_numero",
       dt.no_documentotipo "documento_tipo"
FROM rh.pessoa p,
     rh.documento d,
     rh.documento_tipo dt,
     agrocomum.inscricaoestadual ie,
     agrocomum.propriedade pr
WHERE p.id = d.id_pessoa
  AND d.id_documento_tipo = dt.id_documentotipo
  AND p.id = ie.id_pessoa
  AND ie.id_inscricaoestadual = pr.id_inscricaoestadual
  AND p.ts_pessoa > :sql_last_value
ORDER BY p.id

