package com.mycompany.myapp.web.rest;

import com.codahale.metrics.annotation.Timed;
import com.mycompany.myapp.security.AuthoritiesConstants;
import com.mycompany.myapp.security.SecurityUtils;
import com.mycompany.myapp.service.ElasticsearchIndexGtaService;
import com.mycompany.myapp.service.ElasticsearchIndexService;
import com.mycompany.myapp.web.rest.util.HeaderUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

/**
 * REST controller for managing Elasticsearch index.
 */
@RestController
@RequestMapping("/api")
public class ElasticsearchIndexResource {

    private final Logger log = LoggerFactory.getLogger(ElasticsearchIndexResource.class);

    private final ElasticsearchIndexService elasticsearchIndexService;

    private final ElasticsearchIndexGtaService elasticsearchIndexGtaService;

    public ElasticsearchIndexResource(ElasticsearchIndexService elasticsearchIndexService,
                                      ElasticsearchIndexGtaService elasticsearchIndexGtaService) {
        this.elasticsearchIndexService = elasticsearchIndexService;
        this.elasticsearchIndexGtaService = elasticsearchIndexGtaService;
    }

    /**
     * POST  /elasticsearch/index -> Reindex all Elasticsearch documents
     */
    @PostMapping("/elasticsearch/gta")
    @Timed
    @Secured(AuthoritiesConstants.ADMIN)
    public ResponseEntity<Void> reindexGta() throws URISyntaxException {
        log.info("REST request to reindex Elasticsearch Gta by user : {}", SecurityUtils.getCurrentUserLogin());
        elasticsearchIndexGtaService.reindexForClass();
        return ResponseEntity.accepted()
            .headers(HeaderUtil.createAlert("elasticsearch.reindex.accepted", null))
            .build();
    }

/*
    */
/**
     * POST  /elasticsearch/index -> Reindex all Elasticsearch documents
     *//*

    @PostMapping("/elasticsearch/index")
    @Timed
    @Secured(AuthoritiesConstants.ADMIN)
    public ResponseEntity<Void> reindexAll() throws URISyntaxException {
        log.info("REST request to reindex Elasticsearch by user : {}", SecurityUtils.getCurrentUserLogin());
        elasticsearchIndexService.reindexAll();
        return ResponseEntity.accepted()
            .headers(HeaderUtil.createAlert("elasticsearch.reindex.accepted", null))
            .build();
    }

    */
/**
     * POST  /elasticsearch/selected -> Reindex selected Elasticsearch documents
     *//*

    @PostMapping("/elasticsearch/selected")
    @Timed
    @Secured(AuthoritiesConstants.ADMIN)
    public ResponseEntity<Void> reindexSelected(@RequestParam String selectedEntitie) throws URISyntaxException {
        log.info("REST request to reindex {} Elasticsearch by user : {}", selectedEntitie, SecurityUtils.getCurrentUserLogin());
        List<String> selectedEntities = new ArrayList<>();
        selectedEntities.add(selectedEntitie.toLowerCase());
        elasticsearchIndexService.reindexSelected(selectedEntities, false);
        return ResponseEntity.accepted()
            .headers(HeaderUtil.createAlert("elasticsearch.reindex.acceptedSelected", ""))
            .build();
    }
*/

}
