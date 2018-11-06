package com.mycompany.myapp.service;

import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.repository.GtaRepository;
import com.mycompany.myapp.repository.search.GtaSearchRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static org.elasticsearch.index.query.QueryBuilders.*;

/**
 * Service Implementation for managing Gta.
 */
@Service
@Transactional
public class GtaService {

    private final Logger log = LoggerFactory.getLogger(GtaService.class);

    private GtaRepository gtaRepository;

    private GtaSearchRepository gtaSearchRepository;

    public GtaService(GtaRepository gtaRepository, GtaSearchRepository gtaSearchRepository) {
        this.gtaRepository = gtaRepository;
        this.gtaSearchRepository = gtaSearchRepository;
    }

    /**
     * Save a gta.
     *
     * @param gta the entity to save
     * @return the persisted entity
     */
    public Gta save(Gta gta) {
        log.debug("Request to save Gta : {}", gta);
        Gta result = gtaRepository.save(gta);
        gtaSearchRepository.save(result);
        return result;
    }

    /**
     * Get all the gtas.
     *
     * @param pageable the pagination information
     * @return the list of entities
     */
    @Transactional(readOnly = true)
    public Page<Gta> findAll(Pageable pageable) {
        log.debug("Request to get all Gtas");
        return gtaRepository.findAll(pageable);
    }


    /**
     * Get one gta by id.
     *
     * @param id the id of the entity
     * @return the entity
     */
    @Transactional(readOnly = true)
    public Optional<Gta> findOne(Integer id) {
        log.debug("Request to get Gta : {}", id);
        return gtaRepository.findById(id);
    }

    /**
     * Delete the gta by id.
     *
     * @param id the id of the entity
     */
    public void delete(Integer id) {
        log.debug("Request to delete Gta : {}", id);
        gtaRepository.deleteById(id);
        gtaSearchRepository.deleteById(id);
    }

    /**
     * Search for the gta corresponding to the query.
     *
     * @param query the query of the search
     * @param pageable the pagination information
     * @return the list of entities
     */
    @Transactional(readOnly = true)
    public Page<Gta> search(String query, Pageable pageable) {
        log.debug("Request to search for a page of Gtas for query {}", query);
        return gtaSearchRepository.search(queryStringQuery(query), pageable);    }
}
