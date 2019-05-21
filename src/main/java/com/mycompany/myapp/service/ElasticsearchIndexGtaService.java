package com.mycompany.myapp.service;

import com.codahale.metrics.annotation.Timed;
import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.repository.GtaRepository;
import com.mycompany.myapp.repository.search.GtaDTOSearchRepository;
import com.mycompany.myapp.service.dto.GtaDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ElasticsearchIndexGtaService {

    private static final Lock reindexLock = new ReentrantLock();

    private final Logger log = LoggerFactory.getLogger(ElasticsearchIndexGtaService.class);

    private final GtaRepository gtaRepository;

    private final GtaService gtaService;

    private final GtaDTOSearchRepository gtaDTOSearchRepository;

    private final ElasticsearchOperations elasticsearchTemplate;

    public ElasticsearchIndexGtaService(

        GtaRepository gtaRepository,
        GtaService gtaService, GtaDTOSearchRepository gtaDTOSearchRepository,
        ElasticsearchOperations elasticsearchTemplate) {
        this.gtaRepository = gtaRepository;
        this.gtaService = gtaService;
        this.gtaDTOSearchRepository = gtaDTOSearchRepository;
        this.elasticsearchTemplate = elasticsearchTemplate;
    }

    private static <T> Collection<List<T>> partition(List<T> list, int size) {
        final AtomicInteger counter = new AtomicInteger(0);

        return list.stream()
            .collect(Collectors.groupingBy(it -> counter.getAndIncrement() / size))
            .values();
    }

    @Async
    @Timed
    public void reindexForClass() {

        if (!elasticsearchTemplate.indexExists(GtaDTO.class)) {
            elasticsearchTemplate.createIndex(GtaDTO.class);
            //elasticsearchTemplate.putMapping(GtaDTO.class);
        }

        int size = 300000;
        long count = gtaRepository.count();
        for (int i = 0; i <= count / size; i++) {
            Pageable page = PageRequest.of(i, size);
            log.info("Indexing {} Indexing page {} of {}, size {}, total {}", Gta.class.getSimpleName(), i, count / size, size, count);
            List<GtaDTO> listBD = gtaRepository.findAllDataMapping(page);

            log.info("Start Partition in {}", 10000);
            Collection<List<GtaDTO>> lists = partition(listBD, 10000);

            int index = 1;
            for (List<GtaDTO> list : lists) {
                log.info("Saving of {}", index++);
                gtaDTOSearchRepository.saveAll(list);
            }
        }

        log.info("Elasticsearch: Indexed all rows for {}", Gta.class.getSimpleName());
    }
}
