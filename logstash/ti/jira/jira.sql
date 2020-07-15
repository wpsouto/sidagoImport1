select ji.id                                                                                                       AS id,
       ji.created                                                                                                  AS criado,
       ji.creator                                                                                                  AS solicitante,
       jp.pkey || '-' || ji.issuenum                                                                               AS codigo,
       jt.pname                                                                                                    AS tipo,
       js.pname                                                                                                    AS status,
       cfv_01.textvalue                                                                                            AS modulo,
       cfv_02.textvalue                                                                                            AS servico,
       CASE
           WHEN cfv_03.stringvalue = '11413' THEN 'P'
           WHEN cfv_03.stringvalue = '11414' THEN 'M'
           WHEN cfv_03.stringvalue = '11415' THEN 'G'
           END                                                                                                     AS tamanho,
       ji.updated                                                                                                  AS atualizado,
       ji.resolutiondate                                                                                           AS resolvido,
       ji_andamento.created                                                                                        AS andamento,
       ji_concluido.created                                                                                        AS concluido,
       extract(DAY FROM COALESCE(ji.resolutiondate, CURRENT_TIMESTAMP) - ji.created)                               AS lead_time_day,
       extract(DAY FROM COALESCE(ji.resolutiondate, CURRENT_TIMESTAMP) - ji.created) || ' dias ' ||
       extract(HOUR FROM COALESCE(ji.resolutiondate, CURRENT_TIMESTAMP) - ji.created) || ' horas ' ||
       extract(MINUTE FROM COALESCE(ji.resolutiondate, CURRENT_TIMESTAMP) - ji.created) || ' minutos'              AS lead_time,

       extract(DAY FROM COALESCE(ji_concluido.created, CURRENT_TIMESTAMP) - ji_andamento.created)                  AS cycle_time_day,
       extract(DAY FROM COALESCE(ji_concluido.created, CURRENT_TIMESTAMP) - ji_andamento.created) || ' dias ' ||
       extract(HOUR FROM COALESCE(ji_concluido.created, CURRENT_TIMESTAMP) - ji_andamento.created) || ' horas ' ||
       extract(MINUTE FROM COALESCE(ji_concluido.created, CURRENT_TIMESTAMP) - ji_andamento.created) || ' minutos' AS cycle_time
from project AS jp
         INNER JOIN jiraissue AS ji ON jp.id = ji.project
         INNER JOIN issuetype AS jt ON ji.issuetype = jt.id
         INNER JOIN issuestatus AS js ON ji.issuestatus = js.id
         LEFT JOIN customfieldvalue AS cfv_01 ON ji.id = cfv_01.issue AND cfv_01.customfield = 10904
         LEFT JOIN customfieldvalue AS cfv_02 ON ji.id = cfv_02.issue AND cfv_02.customfield = 10905
         LEFT JOIN customfieldvalue AS cfv_03 ON ji.id = cfv_03.issue AND cfv_03.customfield = 11702
         LEFT JOIN (SELECT cg.issueid      AS id,
                           min(cg.created) AS created
                    FROM changegroup cg
                             inner join changeitem ci on ci.groupid = cg.id AND ci.FIELDTYPE = 'jira' AND ci.FIELD = 'status'
                    WHERE ci.newvalue = '3'
                    GROUP BY cg.issueid) AS ji_andamento ON ji_andamento.id = ji.id
         LEFT JOIN (SELECT cg.issueid      AS id,
                           max(cg.created) AS created
                    FROM changegroup cg
                             inner join changeitem ci on ci.groupid = cg.id AND ci.FIELDTYPE = 'jira' AND ci.FIELD = 'status'
                    WHERE ci.newvalue = '10001'
                    GROUP BY cg.issueid) AS ji_concluido ON ji_concluido.id = ji.id
WHERE jp.pkey = 'SID'
  AND jt.id <> '10000'
ORDER BY jp.pkey, ji.issuenum desc
