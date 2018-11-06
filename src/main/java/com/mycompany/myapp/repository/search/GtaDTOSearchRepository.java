package com.mycompany.myapp.repository.search;

import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.service.dto.GtaDTO;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

/**
 * Spring Data Elasticsearch repository for the Gta entity.
 */
public interface GtaDTOSearchRepository extends ElasticsearchRepository<GtaDTO, Integer> {
}
