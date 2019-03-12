package com.mycompany.myapp.service;

import com.codahale.metrics.annotation.Timed;
import com.mycompany.myapp.domain.TermoFiscalizacao;
import com.mycompany.myapp.repository.TermoFiscalizacaoRepository;
import com.mycompany.myapp.repository.search.TermoFiscalizacaoDTOSearchRepository;
import com.mycompany.myapp.service.dto.TermoFiscalizacaoDTO;
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
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ElasticsearchIndexTermoFiscalizacaoService {

    private final Logger log = LoggerFactory.getLogger(ElasticsearchIndexTermoFiscalizacaoService.class);

    private final TermoFiscalizacaoRepository termoFiscalizacaoRepository;

    private final TermoFiscalizacaoDTOSearchRepository termoFiscalizacaoDTOSearchRepository;

    private final ElasticsearchOperations elasticsearchTemplate;

    public ElasticsearchIndexTermoFiscalizacaoService(TermoFiscalizacaoRepository termoFiscalizacaoRepository, TermoFiscalizacaoDTOSearchRepository termoFiscalizacaoDTOSearchRepository, ElasticsearchOperations elasticsearchTemplate) {
        this.termoFiscalizacaoRepository = termoFiscalizacaoRepository;
        this.termoFiscalizacaoDTOSearchRepository = termoFiscalizacaoDTOSearchRepository;
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

        if (!elasticsearchTemplate.indexExists(TermoFiscalizacaoDTO.class)) {
            elasticsearchTemplate.createIndex(TermoFiscalizacaoDTO.class);
            elasticsearchTemplate.putMapping(TermoFiscalizacaoDTO.class);
        }

        int size = 300000;
        long count = 1000000;//termoFiscalizacaoRepository.count();
        for (int i = 0; i <= count / size; i++) {
            Pageable page = PageRequest.of(i, size);
            log.info("Indexing {} Indexing page {} of {}, size {}, total {}", TermoFiscalizacao.class.getSimpleName(), i, count / size, size, count);
            List<TermoFiscalizacaoDTO> listBD = termoFiscalizacaoRepository.findAllDataMapping(page);

            log.info("Start Partition in {}", 10000);
            Collection<List<TermoFiscalizacaoDTO>> lists = partition(listBD, 10000);

            int index = 1;
            for (List<TermoFiscalizacaoDTO> list : lists) {
                log.info("Saving of {}", index++);
                termoFiscalizacaoDTOSearchRepository.saveAll(list);
            }
        }

        log.info("Elasticsearch: Indexed all rows for {}", TermoFiscalizacao.class.getSimpleName());
    }
}
