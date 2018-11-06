package com.mycompany.myapp.web.rest;

import com.codahale.metrics.annotation.Timed;
import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.service.GtaService;
import com.mycompany.myapp.web.rest.errors.BadRequestAlertException;
import com.mycompany.myapp.web.rest.util.HeaderUtil;
import com.mycompany.myapp.web.rest.util.PaginationUtil;
import io.github.jhipster.web.util.ResponseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.net.URISyntaxException;

import java.util.List;
import java.util.Optional;
import java.util.stream.StreamSupport;

import static org.elasticsearch.index.query.QueryBuilders.*;

/**
 * REST controller for managing Gta.
 */
@RestController
@RequestMapping("/api")
public class GtaResource {

    private final Logger log = LoggerFactory.getLogger(GtaResource.class);

    private static final String ENTITY_NAME = "gta";

    private GtaService gtaService;

    public GtaResource(GtaService gtaService) {
        this.gtaService = gtaService;
    }

    /**
     * POST  /gtas : Create a new gta.
     *
     * @param gta the gta to create
     * @return the ResponseEntity with status 201 (Created) and with body the new gta, or with status 400 (Bad Request) if the gta has already an ID
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @PostMapping("/gtas")
    @Timed
    public ResponseEntity<Gta> createGta(@RequestBody Gta gta) throws URISyntaxException {
        log.debug("REST request to save Gta : {}", gta);
        if (gta.getId() != null) {
            throw new BadRequestAlertException("A new gta cannot already have an ID", ENTITY_NAME, "idexists");
        }
        Gta result = gtaService.save(gta);
        return ResponseEntity.created(new URI("/api/gtas/" + result.getId()))
            .headers(HeaderUtil.createEntityCreationAlert(ENTITY_NAME, result.getId().toString()))
            .body(result);
    }

    /**
     * PUT  /gtas : Updates an existing gta.
     *
     * @param gta the gta to update
     * @return the ResponseEntity with status 200 (OK) and with body the updated gta,
     * or with status 400 (Bad Request) if the gta is not valid,
     * or with status 500 (Internal Server Error) if the gta couldn't be updated
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @PutMapping("/gtas")
    @Timed
    public ResponseEntity<Gta> updateGta(@RequestBody Gta gta) throws URISyntaxException {
        log.debug("REST request to update Gta : {}", gta);
        if (gta.getId() == null) {
            throw new BadRequestAlertException("Invalid id", ENTITY_NAME, "idnull");
        }
        Gta result = gtaService.save(gta);
        return ResponseEntity.ok()
            .headers(HeaderUtil.createEntityUpdateAlert(ENTITY_NAME, gta.getId().toString()))
            .body(result);
    }

    /**
     * GET  /gtas : get all the gtas.
     *
     * @param pageable the pagination information
     * @return the ResponseEntity with status 200 (OK) and the list of gtas in body
     */
    @GetMapping("/gtas")
    @Timed
    public ResponseEntity<List<Gta>> getAllGtas(Pageable pageable) {
        log.debug("REST request to get a page of Gtas");
        Page<Gta> page = gtaService.findAll(pageable);
        HttpHeaders headers = PaginationUtil.generatePaginationHttpHeaders(page, "/api/gtas");
        return new ResponseEntity<>(page.getContent(), headers, HttpStatus.OK);
    }

    /**
     * GET  /gtas/:id : get the "id" gta.
     *
     * @param id the id of the gta to retrieve
     * @return the ResponseEntity with status 200 (OK) and with body the gta, or with status 404 (Not Found)
     */
    @GetMapping("/gtas/{id}")
    @Timed
    public ResponseEntity<Gta> getGta(@PathVariable Integer id) {
        log.debug("REST request to get Gta : {}", id);
        Optional<Gta> gta = gtaService.findOne(id);
        return ResponseUtil.wrapOrNotFound(gta);
    }

    /**
     * DELETE  /gtas/:id : delete the "id" gta.
     *
     * @param id the id of the gta to delete
     * @return the ResponseEntity with status 200 (OK)
     */
    @DeleteMapping("/gtas/{id}")
    @Timed
    public ResponseEntity<Void> deleteGta(@PathVariable Integer id) {
        log.debug("REST request to delete Gta : {}", id);
        gtaService.delete(id);
        return ResponseEntity.ok().headers(HeaderUtil.createEntityDeletionAlert(ENTITY_NAME, id.toString())).build();
    }

    /**
     * SEARCH  /_search/gtas?query=:query : search for the gta corresponding
     * to the query.
     *
     * @param query the query of the gta search
     * @param pageable the pagination information
     * @return the result of the search
     */
    @GetMapping("/_search/gtas")
    @Timed
    public ResponseEntity<List<Gta>> searchGtas(@RequestParam String query, Pageable pageable) {
        log.debug("REST request to search for a page of Gtas for query {}", query);
        Page<Gta> page = gtaService.search(query, pageable);
        HttpHeaders headers = PaginationUtil.generateSearchPaginationHttpHeaders(query, page, "/api/_search/gtas");
        return new ResponseEntity<>(page.getContent(), headers, HttpStatus.OK);
    }

}
