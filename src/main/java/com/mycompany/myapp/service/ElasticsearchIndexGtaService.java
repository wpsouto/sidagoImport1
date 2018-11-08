package com.mycompany.myapp.service;

import com.codahale.metrics.annotation.Timed;
import com.mycompany.myapp.domain.Emissor;
import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.domain.Lotacao;
import com.mycompany.myapp.repository.GtaRepository;
import com.mycompany.myapp.repository.search.GtaDTOSearchRepository;
import com.mycompany.myapp.service.dto.GtaDTO;
import com.mycompany.myapp.service.mapper.GtaMapper;
import org.elasticsearch.ResourceAlreadyExistsException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

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
/*
        elasticsearchTemplate.deleteIndex(GtaDTO.class);
        try {
            elasticsearchTemplate.createIndex(GtaDTO.class);
        } catch (ResourceAlreadyExistsException e) {
            // Do nothing. Index was already concurrently recreated by some other service.
        }
        elasticsearchTemplate.putMapping(GtaDTO.class);
*/

        int size = 6000;
        long count = gtaRepository.count();
        //long count = 5;
        for (int i = 0; i <= count / size; i++) {
            Pageable page = PageRequest.of(i, size, new Sort(new Sort.Order(Direction.ASC, "id")));
            //Pageable page = PageRequest.of(i, size);
            log.info("Indexing {} Indexing page {} of {}, size {}, total {}", Gta.class.getSimpleName(), i, count / size, size, count);
            Page<Gta> results = gtaRepository.findAll(page);
            List<GtaDTO> resultsDTOs = new ArrayList<>();
            int count1 = 1;

            for (Gta gta: results.getContent()) {
                log.info("Indexing of {}", count1);
                Optional<GtaDTO> gtaDTO = gtaDTOSearchRepository.findById(gta.getId());
                if (gtaDTO.isPresent()){
                    gtaDTO.get().setFinalidade(gta.getFinalidade());
                    gtaDTO.get().setEspecie(gta.getEspecie());
                    gtaDTO.get().setTransporte(gta.getTipoTransporte());
                    gtaDTO.get().setEmissor(new Emissor());
                    gtaDTO.get().getEmissor().setId(gta.getEmissor().getId());
                    gtaDTO.get().getEmissor().setNome(gta.getEmissor().getNome());
                    gtaDTO.get().getEmissor().setLotacao(new Lotacao());
                    gtaDTO.get().getEmissor().getLotacao().setId(gta.getLotacao().getId());
                    gtaDTO.get().getEmissor().getLotacao().setNome(gta.getLotacao().getNome());
                    resultsDTOs.add(gtaDTO.get());
                    //gtaDTOSearchRepository.save(gtaDTO.get());
                }
                count1++;
            }

            //List<GtaDTO> resultsDTOs = gtaMapper.gtasToGtaDTOs(results.getContent());

            gtaDTOSearchRepository.saveAll(resultsDTOs);
        }

        log.info("Elasticsearch: Indexed all rows for {}", Gta.class.getSimpleName());
    }

    @Async
    @Timed
    /**
     * Gerando dados do tipo json
     */
    public void fase_01() {

        if (!elasticsearchTemplate.indexExists(GtaDTO.class)) {
            elasticsearchTemplate.putMapping(GtaDTO.class);
        }

        int size = 10000;
        long count = gtaRepository.count();
        //long count = 5;
        for (int i = 0; i <= count / size; i++) {
            Pageable page = PageRequest.of(i, size, new Sort(new Sort.Order(Direction.ASC, "id")));
            //Pageable page = PageRequest.of(i, size);
            log.info("Indexing {} Indexing page {} of {}, size {}, total {}", Gta.class.getSimpleName(), i, count / size, size, count);
            Page<Gta> results = gtaRepository.findAll(page);
            List<GtaDTO> resultsDTOs = gtaMapper.gtasToGtaDTOs(results.getContent());
            gtaDTOSearchRepository.saveAll(resultsDTOs);
        }

        log.info("Elasticsearch: Indexed all rows for {}", Gta.class.getSimpleName());
    }

}

