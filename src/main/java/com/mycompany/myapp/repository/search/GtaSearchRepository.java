package com.mycompany.myapp.repository.search;

import com.mycompany.myapp.domain.Gta;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

/**
 * Spring Data Elasticsearch repository for the Gta entity.
 */
public interface GtaSearchRepository extends ElasticsearchRepository<Gta, Integer> {
}
