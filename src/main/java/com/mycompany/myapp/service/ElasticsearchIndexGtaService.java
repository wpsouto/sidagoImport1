package com.mycompany.myapp.service;

import com.codahale.metrics.annotation.Timed;
import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.repository.GtaRepository;
import com.mycompany.myapp.repository.search.GtaDTOSearchRepository;
import com.mycompany.myapp.repository.search.GtaSearchRepository;
import com.mycompany.myapp.service.dto.GtaDTO;
import com.mycompany.myapp.service.mapper.GtaMapper;
import org.elasticsearch.ResourceAlreadyExistsException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import static org.springframework.data.domain.Sort.*;

@Service
@Transactional(readOnly = true)
public class ElasticsearchIndexGtaService {

    private static final Lock reindexLock = new ReentrantLock();

    private final Logger log = LoggerFactory.getLogger(ElasticsearchIndexGtaService.class);

    private final GtaRepository gtaRepository;

    private final GtaService gtaService;

    private final GtaDTOSearchRepository gtaDTOSearchRepository;

    private final GtaMapper gtaMapper;

    private final ElasticsearchOperations elasticsearchTemplate;

    public ElasticsearchIndexGtaService(

        GtaRepository gtaRepository,
        GtaSearchRepository gtaSearchRepository,
        GtaService gtaService, GtaDTOSearchRepository gtaDTOSearchRepository,
        GtaMapper gtaMapper,
        ElasticsearchOperations elasticsearchTemplate) {
        this.gtaRepository = gtaRepository;
        this.gtaService = gtaService;
        this.gtaDTOSearchRepository = gtaDTOSearchRepository;
        this.gtaMapper = gtaMapper;
        this.elasticsearchTemplate = elasticsearchTemplate;
    }

    @Async
    @Timed
    public void reindexForClass() {
        elasticsearchTemplate.deleteIndex(GtaDTO.class);
        try {
            elasticsearchTemplate.createIndex(GtaDTO.class);
        } catch (ResourceAlreadyExistsException e) {
            // Do nothing. Index was already concurrently recreated by some other service.
        }
        elasticsearchTemplate.putMapping(GtaDTO.class);

        int size = 5000;
        long count = gtaRepository.count();
        //long count = 5;
        for (int i = 0; i <= count / size; i++) {
//            Pageable page = PageRequest.of(i, size, new Sort(new Order(Direction.ASC, "id")));
            Pageable page = PageRequest.of(i, size);
            log.info("Indexing {} Indexing page {} of {}, size {}, total {}", Gta.class.getSimpleName(), i, count / size, size, count);
            List<GtaDTO> results = gtaRepository.findAll1(page);
            //List<GtaDTO> resultsDTOs = gtaMapper.gtasToGtaDTOs(results.getContent());
            gtaDTOSearchRepository.saveAll(results);
        }

        log.info("Elasticsearch: Indexed all rows for {}", Gta.class.getSimpleName());

        //Last Update
        // 2018-11-06 09:29:34.950  INFO 21462 --- [rt-1-Executor-2] c.m.m.s.ElasticsearchIndexGtaService     : Indexing Gta Indexing page 158 of 1530, size 5000, total7650115
    }
}
