create function empresa_situacao_cadastral_kibana(idinscricaoestadual integer, idclassificacao integer, idsituacaocadastral integer, dtcredenciamento timestamp without time zone, idetapa integer, dtvencimento timestamp without time zone) returns text
immutable
strict
language plpgsql
as
$$
DECLARE
situacao    integer;
result      text;
sqlQu       text;
documentos  record;
resultadoTt integer;
resultadoEp text;
BEGIN

sqlQu := 'SELECT COUNT(e.id_etaparecadastramento)                                                         AS total,
                      replace(replace(agrocomum.array_distinct(array_agg(e.id_etaparecadastramento ORDER BY e.ano ASC))::text,' || quote_literal('{') || ',' || quote_literal('') || '),' ||
quote_literal('}') || ',' || quote_literal('') || ') AS etapa
    FROM agrocomum.etapa_recadastramento AS e
    WHERE e.ano::int = extract(year from to_date(' || quote_literal(dtcredenciamento) || ',''YYYY-MM-DD'')) OR e.ano::int = extract(year from CURRENT_DATE)';
EXECUTE sqlQu INTO documentos;

resultadoTt := documentos.total;
resultadoEp := documentos.etapa;

situacao := agrocomum.empresa_situacao_cadastral(idInscricaoestadual, idClassificacao, idSituacaocadastral, idEtapa, dtVencimento, resultadoTt, resultadoEp);

CASE situacao
WHEN 1 THEN
result = 'Regular';
WHEN 2 THEN
result = 'Irregular - Aguardando Envio Cadastro';
WHEN 3 THEN
result = 'Irregular - Cadastro Avaliando';
WHEN 4 THEN
result = 'Irregular - Cadastro Recusado';
WHEN 5 THEN
result = 'Suspensa';
WHEN 6 THEN
result = 'Descredenciada';
WHEN 7 THEN
result = 'Isento';
WHEN 8 THEN
result = 'Erro de Cadastro';
ELSE
result = 'Não Informado';
END CASE;

return result;
END;
$$;

