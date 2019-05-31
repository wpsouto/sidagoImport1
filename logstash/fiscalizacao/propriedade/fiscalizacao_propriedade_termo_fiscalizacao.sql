SELECT tf.id_inscricaoestadual || '_' || EXTRACT(epoch from DATE_TRUNC('month', tf.dt_criacaotermo)::DATE) AS id_mes,
       'Sim'                                                                                               AS propriedade_fiscalizada,
       count(tf.id_termofiscalizacao)                                                                      AS termo_fiscalizacao_quantidade,
       DATE_TRUNC('month', dt_criacaotermo)::DATE                                                          AS termo_fiscalizacao_emissao
FROM fisc.termo_fiscalizacao AS tf
WHERE tf.ativo = true
  AND tf.no_entidade = 'propriedade'
  AND DATE_TRUNC('month', dt_criacaotermo)::DATE = DATE_TRUNC('month', current_date - interval '1 month')::DATE
GROUP BY id_mes, termo_fiscalizacao_emissao
