/usr/share/elasticsearch


scp *.java root@elasticteste1.agrodefesa.go.gov.br:/usr/share/elasticsearch

javac -cp "./modules/x-pack-core/x-pack-core-7.0.1.jar:./lib/*" LicenseVerifier.java
javac -cp "./modules/x-pack-core/x-pack-core-7.0.1.jar:./lib/*" XPackBuild.java

scp x-pack-core-7.0.1.jar root@elasticteste2.agrodefesa.go.gov.br:/usr/share/elasticsearch/modules/x-pack-core

curl https://elasticteste1.agrodefesa.go.gov.br:9200/_cat/indices?v -u elastic

curl -u elastic:123456 http://elasticteste2.agrodefesa.go.gov.br:9200

curl -u elastic:123456 http://elasticteste2.agrodefesa.go.gov.br:9200/_cluster/health?pretty

bin/elasticsearch-certutil ca
bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12
[root@dlp ~]# chgrp elasticsearch elastic-certificates.p12 elastic-stack-ca.p12
[root@dlp ~]# chmod 640 elastic-certificates.p12 elastic-stack-ca.p12
[root@dlp ~]# mv elastic-certificates.p12 elastic-stack-ca.p12 /etc/elasticsearch/

{
	"license": {
		"uid": "9gfhf46-5g78-4f1e-b5a4-afet359bc3a3",
		"type": "platinum",
		"issue_date_in_millis": 1534723200000,
		"expiry_date_in_millis": 2544271999999,
		"max_nodes": 100,
		"issued_to": "www.plaza4me.com",
		"issuer": "Web Form",
		"signature": "AAAAAwAAAA3lQFlr4GED3cGRsdfgrDDFEWGN0hjZDBGYnVyRXpCOsdfasdfsgEfghgdg3423MVZwUzRxVk1PSmkxagfsdf3242UWh3bHZVUTllbXNPbzBUemtnbWpBbmlWRmRZb25KNFlBR2x0TXc2K2p1Y1VtMG1UQU9TRGZVSGRwaEJGUjE3bXd3LzRqZ05iLzRteWFNekdxRGpIYlFwYkJiNUs0U1hTVlJKNVlXekMrSlVUdFIvV0FNeWdOYnlESDc3MWhlY3hSQmdKSjJ2ZTcvYlBFOHhPQlV3ZHdDQ0tHcG5uOElCaDJ4K1hob29xSG85N0kvTWV3THhlQk9NL01VMFRjNDZpZEVXeUtUMXIyMlIveFpJUkk2WUdveEZaME9XWitGUi9WNTZVQW1FMG1DenhZU0ZmeXlZakVEMjZFT2NvOWxpZGlqVmlHNC8rWVVUYzMwRGVySHpIdURzKzFiRDl4TmM1TUp2VTBOUlJZUlAyV0ZVL2kvVk10L0NsbXNFYVZwT3NSU082dFNNa2prQ0ZsclZ4NTltbU1CVE5lR09Bck93V2J1Y3c9PQAAAQCGcZtOlZwj0Rnl2MUjERG94a+xcifpVAurIA+z4rroxaqaewpb2MJLZVJt1ZCGeKB0KIWRAm2pkPjM2JigjaPIUBhpW4/yUzbdRtRuQB4loEKd7/p9EbHDh5GzeI8qfkMh3j7QaAlz4Bk+eett+ZNqNXHEdkr+Re9psdnqfUESz1uROhMoYWbn/Bdd0AJLKzhRnEOE972xdnAar8bCP1DIDljI9IOnYhEc6O6CboKCMJY4AWOvJY83bud4FO25hrKf6bMy0F2oO2yUkVV0UiFMX19JbhcC+WIAgxMk/KG7e/MqR8bJ1jNu2usMlgkvV97BxiPogTujFnTQxoHdpNdR",
		"start_date_in_millis": 1534723200000
	}
}


- Atualize o tamanho padrão do heap do Elasticsearch modificando a propriedade ES_HEAP_SIZE no arquivo /etc/sysconfig/elasticsearch.
- O tamanho do heap deve ser 50% da memória do servidor. Por exemplo, em um nó do Elasticsearch de 24 GB, aloque 12 GB na propriedade ES_HEAP_SIZE para obter um desempenho ideal.
- cat /proc/meminf

