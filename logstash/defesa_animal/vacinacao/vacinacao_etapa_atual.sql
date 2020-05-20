SELECT s.id_saldo                                                              AS id,
       s.nu_saldo                                                              AS estratificacao_saldo,

       UPPER(pd.nome)                                                          AS vacinacao_emissor_nome,
       lote.nome                                                               AS vacinacao_emissor_lotacao_nome,
       reg.nome                                                                AS vacinacao_emissor_lotacao_regional_nome,

       52                                                                      AS vacinacao_campanha_id,
       '1º Etapa 2020 Febre Aftosa/Antirrábica'                                AS vacinacao_campanha_nome,
       '2020-04-20'                                                            AS vacinacao_campanha_inicio,
       '2020-05-31'                                                            AS vacinacao_campanha_fim,
       '2020-06-27'                                                            AS vacinacao_campanha_fechamento,

       CASE
           WHEN vd.bo_produtor = TRUE THEN 'Produtor'
           WHEN vd.bo_produtor = FALSE THEN 'Funcionário'
           END                                                                 AS vacinacao_emissor_tipo,

       COALESCE(afto_transf.vacinado, COALESCE(anti_transf.vacinado, 'Não'))   AS vacinacao_transferencia,
       vd.dt_declaracao                                                        AS vacinacao_data,

       COALESCE(anti.vacinado, COALESCE(anti_transf.vacinado, 'Não'))          AS vacinacao_antirrabica_vacinado,
       COALESCE(anti.quantidade, COALESCE(anti_transf.quantidade, 0))          AS vacinacao_antirrabica_quantidade,
       COALESCE(anti.tipo, anti_transf.tipo)                                   AS vacinacao_antirrabica_tipo,
       COALESCE(anti.quantidade, COALESCE(anti_transf.quantidade, s.nu_saldo)) AS vacinacao_antirrabica_diferenca,
       CASE
           WHEN anti.situacao THEN 'Não'
           WHEN anti.situacao = FALSE THEN 'Sim'
           ELSE 'Não'
           END                                                                 AS vacinacao_antirrabica_cancelada,

       COALESCE(afto.vacinado, COALESCE(afto_transf.vacinado, 'Não'))          AS vacinacao_aftosa_vacinado,
       COALESCE(afto.quantidade, COALESCE(afto_transf.quantidade, 0))          AS vacinacao_aftosa_quantidade,
       COALESCE(afto.tipo, afto_transf.tipo)                                   AS vacinacao_aftosa_tipo,
       COALESCE(afto.quantidade, COALESCE(afto_transf.quantidade, s.nu_saldo)) AS vacinacao_aftosa_diferenca,
       CASE
           WHEN afto.situacao THEN 'Não'
           WHEN afto.situacao = FALSE THEN 'Sim'
           ELSE 'Não'
           END                                                                 AS vacinacao_aftosa_cancelada

FROM dsa.saldo AS s
         INNER JOIN dsa.nucleo AS n ON s.id_nucleo = n.id_nucleo
         INNER JOIN dsa.especie AS es ON n.id_especie = es.id
         INNER JOIN dsa.exploracao_propriedade AS ep ON n.id_exploracao = ep.id_exploracao
         INNER JOIN agrocomum.inscricaoestadual AS ie ON ep.id_inscricaoestadual = ie.id_inscricaoestadual
         LEFT JOIN dsa.vacinacao_declaracao AS vd ON vd.id_inscricaoestadual = ie.id_inscricaoestadual AND vd.id_campanha_vacina = 52
         LEFT JOIN rh.pessoa AS pd ON pd.id = vd.id_pessoa
         LEFT JOIN rh.lotacao_funcionario AS lf ON lf.id_pessoa = vd.id_pessoa AND lf.dt_final IS NULL
         LEFT JOIN rh.lotacao AS lote ON lf.id_lotacao = lote.id
         LEFT JOIN rh.lotacao AS reg ON lote.id_lotacao_pai = reg.id

         LEFT JOIN (SELECT 'Sim'                    AS vacinado,
                           COALESCE(nu_vacinado, 0) AS quantidade,
                           va.bo_situacao           AS situacao,
                           CASE
                               WHEN tp_vacinacao = 'PR' THEN 'Produtor'
                               WHEN tp_vacinacao = 'OF' THEN 'Oficial'
                               WHEN tp_vacinacao = 'AS' THEN 'Assistida'
                               WHEN tp_vacinacao = 'FI' THEN 'Fiscalizada'
                               WHEN tp_vacinacao = 'VE' THEN 'Veterinario'
                               ELSE 'Produtor'
                               END                  AS tipo,
                           va.id_inscricaoestadual,
                           ve.id_estratificacao
                    FROM dsa.vacinacao AS va
                             INNER JOIN dsa.vacinacao_estratificacao AS ve ON ve.id_vacinacao = va.id
                    WHERE va.id_campanha_vacina = 53
                      AND va.tp_origem not in ('RT', 'TG')) AS anti ON anti.id_inscricaoestadual = ie.id_inscricaoestadual AND anti.id_estratificacao = s.id_estratificacao

         LEFT JOIN (SELECT 'Sim'                    AS vacinado,
                           COALESCE(nu_vacinado, 0) AS quantidade,
                           va.bo_situacao           AS situacao,
                           CASE
                               WHEN tp_vacinacao = 'PR' THEN 'Produtor'
                               WHEN tp_vacinacao = 'OF' THEN 'Oficial'
                               WHEN tp_vacinacao = 'AS' THEN 'Assistida'
                               WHEN tp_vacinacao = 'FI' THEN 'Fiscalizada'
                               WHEN tp_vacinacao = 'VE' THEN 'Veterinario'
                               ELSE 'Produtor'
                               END                  AS tipo,
                           va.id_inscricaoestadual,
                           ve.id_estratificacao
                    FROM dsa.vacinacao AS va
                             INNER JOIN dsa.vacinacao_estratificacao AS ve ON ve.id_vacinacao = va.id
                    WHERE va.id_campanha_vacina = 52
                      AND va.tp_origem not in ('RT', 'TG')) AS afto ON afto.id_inscricaoestadual = ie.id_inscricaoestadual AND afto.id_estratificacao = s.id_estratificacao

         LEFT JOIN (SELECT 'Sim'          AS vacinado,
                           0              AS quantidade,
                           va.bo_situacao AS situacao,
                           CASE
                               WHEN tp_vacinacao = 'PR' THEN 'Produtor'
                               WHEN tp_vacinacao = 'OF' THEN 'Oficial'
                               WHEN tp_vacinacao = 'AS' THEN 'Assistida'
                               WHEN tp_vacinacao = 'FI' THEN 'Fiscalizada'
                               WHEN tp_vacinacao = 'VE' THEN 'Veterinario'
                               ELSE 'Produtor'
                               END        AS tipo,
                           va.id_inscricaoestadual,
                           ve.id_estratificacao
                    FROM dsa.vacinacao AS va
                             INNER JOIN dsa.vacinacao_estratificacao AS ve ON ve.id_vacinacao = va.id
                    WHERE va.id_campanha_vacina = 53
                      AND va.tp_origem = 'TG') AS anti_transf ON anti_transf.id_inscricaoestadual = ie.id_inscricaoestadual AND anti_transf.id_estratificacao = s.id_estratificacao

         LEFT JOIN (SELECT 'Sim'          AS vacinado,
                           0              AS quantidade,
                           va.bo_situacao AS situacao,
                           CASE
                               WHEN tp_vacinacao = 'PR' THEN 'Produtor'
                               WHEN tp_vacinacao = 'OF' THEN 'Oficial'
                               WHEN tp_vacinacao = 'AS' THEN 'Assistida'
                               WHEN tp_vacinacao = 'FI' THEN 'Fiscalizada'
                               WHEN tp_vacinacao = 'VE' THEN 'Veterinario'
                               ELSE 'Produtor'
                               END        AS tipo,
                           va.id_inscricaoestadual,
                           ve.id_estratificacao
                    FROM dsa.vacinacao AS va
                             INNER JOIN dsa.vacinacao_estratificacao AS ve ON ve.id_vacinacao = va.id
                    WHERE va.id_campanha_vacina = 52
                      AND va.tp_origem = 'TG') AS afto_transf ON afto_transf.id_inscricaoestadual = ie.id_inscricaoestadual AND afto_transf.id_estratificacao = s.id_estratificacao

WHERE es.id_grupo = 1
ORDER BY s.id_saldo
