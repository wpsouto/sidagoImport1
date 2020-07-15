SELECT p.id "id",
       p.nome "nome",
       c.id "carro.id",
       c.marca "carro.marca"
from demo.proprietario p
     LEFT JOIN demo.carro c ON p.id = c.proprietario_id
ORDER BY p.id
