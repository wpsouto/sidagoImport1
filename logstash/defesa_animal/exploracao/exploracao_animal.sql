SELECT s.id_saldo                                                                        AS id,
       case when pro.bo_ativo then 'Sim' else 'Não' end                                  AS ativa,
       case when n.bo_ativo then 'Não' else 'Sim' end                                    AS bloqueado,
       g.no_grupo                                                                        AS especie_grupo,
       es.no_especie                                                                     AS especie_nome,

       p.nome                                                                            AS produtor_nome,
       d.numero                                                                          AS produtor_documento,

       ie.id_inscricaoestadual                                                           AS propriedade_id,
       ie.no_fantasia                                                                    AS propriedade_nome,
       ie.nu_inscricaoestadual                                                           AS propriedade_ie,
       pai.nome                                                                          AS propriedade_regional_nome,
       ll.loc_no                                                                         AS propriedade_municipio_nome,
       ll.ufe_sg                                                                         AS propriedade_municipio_uf,
       COALESCE(ll.lat, 0)                                                               AS propriedade_municipio_localizacao_latitude,
       COALESCE(ll.lon, 0)                                                               AS propriedade_municipio_localizacao_longitude,

       et.nome                                                                           AS estratificacao_nome,

       CASE
           WHEN et.tp_sexo = 'FE' THEN 'Femea'
           WHEN et.tp_sexo = 'MA' THEN 'Macho'
           ELSE 'Indefinido'
           END                                                                           AS estratificacao_sexo,
       s.nu_saldo                                                                        AS estratificacao_saldo,
       total.total                                                                       AS estratificacao_total

FROM dsa.exploracao AS e
         INNER JOIN dsa.exploracao_propriedade AS ep ON e.id_exploracao = ep.id_exploracao
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = ep.id_inscricaoestadual
         INNER JOIN agrocomum.propriedade AS pro ON ie.id_inscricaoestadual = pro.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS en ON iee.id_endereco = en.id_endereco
         INNER JOIN dne.log_localidade AS ll ON en.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l
                    ON l.id_localidade = en.id_localidade and l.bo_ativo = true and l.bo_organograma = true and
                       id_lotacaotipo = 3
         INNER JOIN rh.lotacao AS pai ON pai.id = l.id_lotacao_pai

         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN rh.documento AS d ON p.id = d.id_pessoa AND (d.id_documento_tipo = 1 OR d.id_documento_tipo = 2)
         INNER JOIN dsa.nucleo AS n ON e.id_exploracao = n.id_exploracao
         INNER JOIN dsa.especie AS es ON n.id_especie = es.id
         INNER JOIN dsa.grupo AS g ON es.id_grupo = g.id
         INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
         INNER JOIN dsa.estratificacao AS et ON et.id = s.id_estratificacao
         INNER JOIN (SELECT st.id_nucleo, SUM(st.nu_saldo) AS total
                     FROM dsa.saldo st
                     GROUP BY st.id_nucleo) AS total ON total.id_nucleo = s.id_nucleo

ORDER BY s.id_saldo
