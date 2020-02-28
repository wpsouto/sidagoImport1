SELECT up.id_unidadeproducao || '_' || pup.id_produtoup                       AS chave,
       up.id_unidadeproducao                                                  AS id,
       up.nu_unidadeproducao                                                  AS codigo,
       case when up.bo_areacertificada then 'Sim' else 'Não' end              AS certificada,
       case when bol.situacao = 'p' then 'Sim' else 'Não' end                 AS pago,
       up.dt_ultimocodigo::TIMESTAMP                                          AS vencimento,
       case when up.dt_ultimocodigo >= CURRENT_DATE then 'Sim' else 'Não' end AS ativo,

       pp.id_produto                                                          AS produto_id,
       COALESCE(pup.vl_area_produto, 0)                                       AS produto_area,
       pp.ds_nome                                                             AS produto_nome,
       case when pp.bo_culturaperene then 'Sim' else 'Não' end                AS produto_perene,
       c.no_cultivar                                                          AS produto_cultivar,
       EXTRACT(YEAR FROM pup.dt_plantio::TIMESTAMP)::TEXT                     AS produto_ano_plantio,
       pup.dt_plantio::TIMESTAMP                                              AS produto_plantio,
       pup.dt_iniciosafra::TIMESTAMP                                          AS produto_inicioColheita,
       pup.dt_fimsafra::TIMESTAMP                                             AS produto_fimColheita,
       pup.nu_estimativaproducao                                              AS produto_quantidade,

       sa.id_safra                                                            AS safra_id,
       sa.ds_safra                                                            AS safra_descricao,
       sa.dt_inicio::TIMESTAMP                                                AS safra_inicio,
       sa.dt_final::TIMESTAMP                                                 AS safra_fim,

       ie.id_inscricaoestadual                                                AS propriedade_id,
       UPPER(ie.no_fantasia)                                                  AS propriedade_nome,
       ie.nu_inscricaoestadual                                                AS propriedade_ie,
       COALESCE(ie.vl_latitude, 0)                                            AS propriedade_gps_latitude,
       COALESCE(ie.vl_longitude, 0)                                           AS propriedade_gps_longitude,
       llr.nome                                                               AS propriedade_regional_nome,
       ll.loc_no                                                              AS propriedade_municipio_nome,
       ll.ufe_sg                                                              AS propriedade_municipio_uf,
       ll.cod_ibge                                                            AS propriedade_municipio_ibge,
       COALESCE(ll.lat, 0)                                                    AS propriedade_municipio_gps_latitude,
       COALESCE(ll.lon, 0)                                                    AS propriedade_municipio_gps_longitude,

       pe.id                                                                  AS produtor_id,
       UPPER(pe.nome)                                                         AS produtor_nome,
       d.numero                                                               AS produtor_documento

FROM gtv.unidade_producao AS up
         INNER JOIN gtv.safra AS sa ON up.id_safra = sa.id_safra
         INNER JOIN agrocomum.inscricaoestadual AS ie ON up.id_inscricaoestadual = ie.id_inscricaoestadual
         INNER JOIN agrocomum.inscricaoestadual_endereco AS iee ON ie.id_inscricaoestadual = iee.id_inscricaoestadual
         INNER JOIN agrocomum.endereco AS e ON iee.id_endereco = e.id_endereco
         INNER JOIN dne.log_localidade AS ll ON e.id_localidade = ll.loc_nu
         INNER JOIN rh.lotacao AS l ON ll.loc_nu = l.id_localidade AND l.id_lotacaotipo = 3 AND bo_organograma = true--Unidade Local
         INNER JOIN rh.lotacao AS llr ON llr.id = l.id_lotacao_pai AND llr.id_lotacaotipo = 2 --Unidade Regional
         INNER JOIN rh.pessoa AS pe ON pe.id = ie.id_pessoa
         INNER JOIN rh.documento AS d ON d.id_pessoa = pe.id AND id_documento_tipo IN (1, 2)
         INNER JOIN gtv.produto_up AS pup ON up.id_unidadeproducao = pup.id_unidadeproducao
         INNER JOIN produtos.subproduto AS s ON pup.id_subproduto = s.id_subproduto
         INNER JOIN produtos.produto AS pp ON s.id_produto = pp.id_produto
         INNER JOIN gtv.cultivar AS c ON pup.id_cultivar = c.id_cultivar
         LEFT JOIN agrofin.boleto AS bol ON bol.id = up.id_dare
ORDER BY up.id_unidadeproducao
