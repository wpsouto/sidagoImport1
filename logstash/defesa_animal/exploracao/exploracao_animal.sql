SELECT s.id_saldo                                            AS id,
       case when pro.bo_ativo then 'Sim' else 'Não' end      AS ativa,
       case when n.bo_ativo then 'Não' else 'Sim' end        AS bloqueado,
       g.no_grupo                                            AS especie_grupo,
       es.no_especie                                         AS especie_nome,

       CASE WHEN mm.bo_antirrabica THEN 'Sim' else 'Não' END AS marcacao_antirrabica,

       UPPER(p.nome)                                         AS produtor_nome,
       d.numero                                              AS produtor_documento,

       ie.id_inscricaoestadual                               AS propriedade_id,
       UPPER(ie.no_fantasia)                                 AS propriedade_nome,
       ie.nu_inscricaoestadual                               AS propriedade_ie,
       COALESCE(pro.vl_area, 0)                              AS propriedade_area,
       COALESCE(ie.vl_latitude, 0)                           AS propriedade_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                          AS propriedade_gps_longitude,

       pai.nome                                              AS propriedade_regional_nome,
       ll.loc_no                                             AS propriedade_municipio_nome,
       ll.ufe_sg                                             AS propriedade_municipio_uf,
       ll.cod_ibge                                           AS propriedade_municipio_ibge,
       COALESCE(ll.lat, 0)                                   AS propriedade_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                   AS propriedade_municipio_gps_longitude,

       CASE
           WHEN ex_ga.tp_areainteresse = 'MA' THEN 'Material de Multiplicação Animal'
           WHEN ex_ga.tp_areainteresse = 'AC' THEN 'Aves Comerciais'
           WHEN ex_ga.tp_areainteresse = 'AS' THEN 'Avicultura de Subsistência'
           WHEN ex_ga.tp_areainteresse = 'OR' THEN 'Ave Ornamental'
           WHEN ex_ga.tp_areainteresse = 'SI' THEN 'Ave Silvestre'

           ELSE 'Não Informada'
           END
                                                             AS exploracao_area_interesse,

       CASE
           WHEN ex_bo.id_finalidadebovideo = 1 THEN 'Corte'
           WHEN ex_bo.id_finalidadebovideo = 2 THEN 'Leite'
           WHEN ex_bo.id_finalidadebovideo = 3 THEN 'Mista'
           WHEN ex_bo.id_finalidadebovideo = 4 THEN 'Não Informada'
           WHEN ex_bo.id_finalidadebovideo = 5 THEN 'Leilão'
           WHEN ex_bo.id_finalidadebovideo = 6 THEN 'Confinamento'

           WHEN ex_bu.id_finalidadebovideo = 1 THEN 'Corte'
           WHEN ex_bu.id_finalidadebovideo = 2 THEN 'Leite'
           WHEN ex_bu.id_finalidadebovideo = 3 THEN 'Mista'
           WHEN ex_bu.id_finalidadebovideo = 4 THEN 'Não Informada'
           WHEN ex_bu.id_finalidadebovideo = 5 THEN 'Leilão'
           WHEN ex_bu.id_finalidadebovideo = 6 THEN 'Confinamento'

           WHEN ex_ga.tp_finalidade = 'CO' THEN 'Corte'
           WHEN ex_ga.tp_finalidade = 'PO' THEN 'Postura'
           WHEN ex_ga.tp_finalidade = 'SI' THEN 'Silvestre'
           WHEN ex_ga.tp_finalidade = 'OR' THEN 'Ornamental'
           WHEN ex_ga.tp_finalidade = 'OU' THEN 'Outros'
           WHEN ex_ga.tp_finalidade = 'RE' THEN 'Reprodução'

           ELSE 'Não Informada'
           END
                                                             AS exploracao_finalidade,

       CASE
           WHEN ex_s.tp_exploracao = 'CR' THEN 'Criatório'
           WHEN ex_s.tp_exploracao = 'GR' THEN 'Granja'

           WHEN ex_ja.tp_exploracao = 'CR' THEN 'Criatório'
           WHEN ex_ja.tp_exploracao = 'GR' THEN 'Granja'

           WHEN STRPOS(ex_aq.tp_exploracao::text, 'RE') > 0 THEN 'Reprodução'
           WHEN STRPOS(ex_aq.tp_exploracao::text, 'RI') > 0 THEN 'Recria'
           WHEN STRPOS(ex_aq.tp_exploracao::text, 'TE') > 0 THEN 'Terminação'
           WHEN STRPOS(ex_aq.tp_exploracao::text, 'RA') > 0 THEN 'Recreação'

           WHEN ex_eq.tp_exploracao = 'AL' THEN 'Alojamento'
           WHEN ex_eq.tp_exploracao = 'CT' THEN 'Centro de Treinamento'
           WHEN ex_eq.tp_exploracao = 'CC' THEN 'Central de Coleta e Reprodução'
           WHEN ex_eq.tp_exploracao = 'CE' THEN 'Central de Eventos'
           WHEN ex_eq.tp_exploracao = 'CP' THEN 'Centro de Pesquisa'
           WHEN ex_eq.tp_exploracao = 'CL' THEN 'Clube do Laço'
           WHEN ex_eq.tp_exploracao = 'ZU' THEN 'Estabelecimento em Zona Urbana'
           WHEN ex_eq.tp_exploracao = 'FC' THEN 'Fazenda de Criação'
           WHEN ex_eq.tp_exploracao = 'HA' THEN 'Haras'
           WHEN ex_eq.tp_exploracao = 'HI' THEN 'Hipódromo'
           WHEN ex_eq.tp_exploracao = 'HV' THEN 'Hospital Veterinário'
           WHEN ex_eq.tp_exploracao = 'JC' THEN 'Jóquei Clube'
           WHEN ex_eq.tp_exploracao = 'PE' THEN 'PEAE'
           WHEN ex_eq.tp_exploracao = 'PF' THEN 'PFE'
           WHEN ex_eq.tp_exploracao = 'PR' THEN 'Propriedade Rural Comum'
           WHEN ex_eq.tp_exploracao = 'SH' THEN 'Sociedade Hípica'
           WHEN ex_eq.tp_exploracao = 'UM' THEN 'Unidade Militar'

           ELSE 'Não Informada'
           END
                                                             AS exploracao_tipo,
       CASE
           WHEN ex_s.tp_producao = 'CC' THEN 'Ciclo completo'
           WHEN ex_s.tp_producao = 'UP' THEN 'Unidade produtora'
           WHEN ex_s.tp_producao = 'CI' THEN 'Central de inseminação'
           WHEN ex_s.tp_producao = 'TE' THEN 'Terminação'
           WHEN ex_s.tp_producao = 'SU' THEN 'Subsistência'
           WHEN ex_s.tp_producao = 'S1' THEN 'Sitio I'
           WHEN ex_s.tp_producao = 'S2' THEN 'Sitio II'
           WHEN ex_s.tp_producao = 'S3' THEN 'Sitio III'

           WHEN ex_ja.tp_producao = 'CC' THEN 'Ciclo completo'
           WHEN ex_ja.tp_producao = 'UP' THEN 'Unidade produtora'
           WHEN ex_ja.tp_producao = 'CI' THEN 'Central de inseminação'
           WHEN ex_ja.tp_producao = 'TE' THEN 'Terminação'
           WHEN ex_ja.tp_producao = 'SU' THEN 'Subsistência'
           WHEN ex_ja.tp_producao = 'S1' THEN 'Sitio I'
           WHEN ex_ja.tp_producao = 'S2' THEN 'Sitio II'
           WHEN ex_ja.tp_producao = 'S3' THEN 'Sitio III'

           ELSE 'Não Informada'
           END                                               AS exploracao_producao,
       CASE
           WHEN total.saldo > 0 THEN 'Sim'
           ELSE 'Não'
           END                                               AS exploracao_positiva,

       total.saldo                                           AS exploracao_total,


       et.nome                                               AS estratificacao_nome,

       CASE
           WHEN et.tp_sexo = 'FE' THEN 'Femea'
           WHEN et.tp_sexo = 'MA' THEN 'Macho'
           ELSE 'Indefinido'
           END                                               AS estratificacao_sexo,

       s.nu_saldo                                            AS estratificacao_saldo


FROM dsa.exploracao AS e
         INNER JOIN dsa.exploracao_propriedade AS ep ON e.id_exploracao = ep.id_exploracao
         LEFT JOIN dsa.exploracao_bovino AS ex_bo ON ex_bo.id_exploracaopropriedade = ep.id_exploracaopropriedade
         LEFT JOIN dsa.exploracao_bubalino AS ex_bu ON ex_bu.id_exploracaopropriedade = ep.id_exploracaopropriedade
         LEFT JOIN dsa.exploracao_equideo_propriedade AS ex_eq ON ex_eq.id_exploracaopropriedade = ep.id_exploracaopropriedade
         LEFT JOIN dsa.exploracao_suino AS ex_s ON ex_s.id_exploracaopropriedade = ep.id_exploracaopropriedade
         LEFT JOIN dsa.exploracao_javali AS ex_ja ON ex_ja.id_exploracaopropriedade = ep.id_exploracaopropriedade
         LEFT JOIN dsa.exploracao_galinha AS ex_ga ON ex_ga.id_exploracaopropriedade = ep.id_exploracaopropriedade
         LEFT JOIN dsa.exploracao_animal_aquatico_propriedade AS ex_aq ON ex_aq.id_exploracaopropriedade = ep.id_exploracaopropriedade
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ie.id_inscricaoestadual = ep.id_inscricaoestadual
         INNER JOIN agrocomum.propriedade AS pro ON ie.id_inscricaoestadual = pro.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS en ON iee.id_endereco = en.id_endereco
         INNER JOIN dne.log_localidade AS ll ON en.id_localidade = ll.loc_nu
         INNER JOIN dsa.marcacoes_municipios AS mm ON mm.id_municipio = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON l.id_localidade = en.id_localidade AND l.bo_ativo = true AND id_lotacaotipo = 3 AND l.bo_organograma = true
         INNER JOIN rh.lotacao AS pai ON pai.id = l.id_lotacao_pai AND pai.id_lotacaotipo = 2 AND pai.bo_ativo = true AND pai.bo_organograma = true
         INNER JOIN rh.pessoa AS p ON ie.id_pessoa = p.id
         INNER JOIN rh.documento AS d ON p.id = d.id_pessoa AND (d.id_documento_tipo = 1 OR d.id_documento_tipo = 2)
         INNER JOIN dsa.nucleo AS n ON e.id_exploracao = n.id_exploracao
         INNER JOIN dsa.especie AS es ON n.id_especie = es.id
         INNER JOIN dsa.grupo AS g ON es.id_grupo = g.id
         INNER JOIN dsa.saldo AS s ON n.id_nucleo = s.id_nucleo
         INNER JOIN dsa.estratificacao AS et ON et.id = s.id_estratificacao
         INNER JOIN (SELECT st.id_nucleo, SUM(st.nu_saldo) AS saldo
                     FROM dsa.saldo st
                     GROUP BY st.id_nucleo) AS total ON total.id_nucleo = s.id_nucleo
WHERE ex_ga.bo_duplicado is not true
ORDER BY s.id_saldo
