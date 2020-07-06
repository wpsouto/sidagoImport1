create function empresa_situacao_financeira_kibana(idinscricaoestadual integer) returns text
immutable
strict
language plpgsql
as
$$
DECLARE
situacao    integer;
result      text;
BEGIN

situacao := agrocomum.empresa_situacao_financeiro(idInscricaoestadual);

CASE situacao
WHEN 100 THEN
result = 'Regular';
WHEN 101 THEN
result = 'Irregular';
WHEN 102 THEN
result = 'Isento';
ELSE
result = 'Não Informado';
END CASE;

return result;
END;
$$;

