package com.mycompany.myapp.repository.search;

import com.mycompany.myapp.service.dto.GtaDTO;
import com.mycompany.myapp.service.dto.TermoFiscalizacaoDTO;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

/**
 * Spring Data Elasticsearch repository for the Gta entity.
 */
public interface TermoFiscalizacaoDTOSearchRepository extends ElasticsearchRepository<TermoFiscalizacaoDTO, Integer> {
}
