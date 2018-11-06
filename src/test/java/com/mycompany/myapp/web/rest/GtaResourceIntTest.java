package com.mycompany.myapp.web.rest;

import com.mycompany.myapp.SidagoImport1App;

import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.repository.GtaRepository;
import com.mycompany.myapp.repository.search.GtaSearchRepository;
import com.mycompany.myapp.service.GtaService;
import com.mycompany.myapp.web.rest.errors.ExceptionTranslator;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.Collections;
import java.util.List;


import static com.mycompany.myapp.web.rest.TestUtil.createFormattingConversionService;
import static org.assertj.core.api.Assertions.assertThat;
import static org.elasticsearch.index.query.QueryBuilders.queryStringQuery;
import static org.hamcrest.Matchers.hasItem;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Test class for the GtaResource REST controller.
 *
 * @see GtaResource
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = SidagoImport1App.class)
public class GtaResourceIntTest {

    private static final String DEFAULT_NUMERO = "AAAAAAAAAA";
    private static final String UPDATED_NUMERO = "BBBBBBBBBB";

    private static final String DEFAULT_SERIE = "AAAAAAAAAA";
    private static final String UPDATED_SERIE = "BBBBBBBBBB";

    private static final Boolean DEFAULT_ATIVO = false;
    private static final Boolean UPDATED_ATIVO = true;

    @Autowired
    private GtaRepository gtaRepository;
    
    @Autowired
    private GtaService gtaService;

    /**
     * This repository is mocked in the com.mycompany.myapp.repository.search test package.
     *
     * @see com.mycompany.myapp.repository.search.GtaSearchRepositoryMockConfiguration
     */
    @Autowired
    private GtaSearchRepository mockGtaSearchRepository;

    @Autowired
    private MappingJackson2HttpMessageConverter jacksonMessageConverter;

    @Autowired
    private PageableHandlerMethodArgumentResolver pageableArgumentResolver;

    @Autowired
    private ExceptionTranslator exceptionTranslator;

    @Autowired
    private EntityManager em;

    private MockMvc restGtaMockMvc;

    private Gta gta;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        final GtaResource gtaResource = new GtaResource(gtaService);
        this.restGtaMockMvc = MockMvcBuilders.standaloneSetup(gtaResource)
            .setCustomArgumentResolvers(pageableArgumentResolver)
            .setControllerAdvice(exceptionTranslator)
            .setConversionService(createFormattingConversionService())
            .setMessageConverters(jacksonMessageConverter).build();
    }

    /**
     * Create an entity for this test.
     *
     * This is a static method, as tests for other entities might also need it,
     * if they test an entity which requires the current entity.
     */
    public static Gta createEntity(EntityManager em) {
        Gta gta = new Gta()
            .numero(DEFAULT_NUMERO)
            .serie(DEFAULT_SERIE)
            .ativo(DEFAULT_ATIVO);
        return gta;
    }

    @Before
    public void initTest() {
        gta = createEntity(em);
    }

    @Test
    @Transactional
    public void createGta() throws Exception {
        int databaseSizeBeforeCreate = gtaRepository.findAll().size();

        // Create the Gta
        restGtaMockMvc.perform(post("/api/gtas")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(gta)))
            .andExpect(status().isCreated());

        // Validate the Gta in the database
        List<Gta> gtaList = gtaRepository.findAll();
        assertThat(gtaList).hasSize(databaseSizeBeforeCreate + 1);
        Gta testGta = gtaList.get(gtaList.size() - 1);
        assertThat(testGta.getNumero()).isEqualTo(DEFAULT_NUMERO);
        assertThat(testGta.getSerie()).isEqualTo(DEFAULT_SERIE);
        assertThat(testGta.isAtivo()).isEqualTo(DEFAULT_ATIVO);

        // Validate the Gta in Elasticsearch
        verify(mockGtaSearchRepository, times(1)).save(testGta);
    }

    @Test
    @Transactional
    public void createGtaWithExistingId() throws Exception {
        int databaseSizeBeforeCreate = gtaRepository.findAll().size();

        // Create the Gta with an existing ID
        gta.setId(1);

        // An entity with an existing ID cannot be created, so this API call must fail
        restGtaMockMvc.perform(post("/api/gtas")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(gta)))
            .andExpect(status().isBadRequest());

        // Validate the Gta in the database
        List<Gta> gtaList = gtaRepository.findAll();
        assertThat(gtaList).hasSize(databaseSizeBeforeCreate);

        // Validate the Gta in Elasticsearch
        verify(mockGtaSearchRepository, times(0)).save(gta);
    }

    @Test
    @Transactional
    public void getAllGtas() throws Exception {
        // Initialize the database
        gtaRepository.saveAndFlush(gta);

        // Get all the gtaList
        restGtaMockMvc.perform(get("/api/gtas?sort=id,desc"))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON_UTF8_VALUE))
            .andExpect(jsonPath("$.[*].id").value(hasItem(gta.getId().intValue())))
            .andExpect(jsonPath("$.[*].numero").value(hasItem(DEFAULT_NUMERO.toString())))
            .andExpect(jsonPath("$.[*].serie").value(hasItem(DEFAULT_SERIE.toString())))
            .andExpect(jsonPath("$.[*].ativo").value(hasItem(DEFAULT_ATIVO.booleanValue())));
    }
    
    @Test
    @Transactional
    public void getGta() throws Exception {
        // Initialize the database
        gtaRepository.saveAndFlush(gta);

        // Get the gta
        restGtaMockMvc.perform(get("/api/gtas/{id}", gta.getId()))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON_UTF8_VALUE))
            .andExpect(jsonPath("$.id").value(gta.getId().intValue()))
            .andExpect(jsonPath("$.numero").value(DEFAULT_NUMERO.toString()))
            .andExpect(jsonPath("$.serie").value(DEFAULT_SERIE.toString()))
            .andExpect(jsonPath("$.ativo").value(DEFAULT_ATIVO.booleanValue()));
    }

    @Test
    @Transactional
    public void getNonExistingGta() throws Exception {
        // Get the gta
        restGtaMockMvc.perform(get("/api/gtas/{id}", Long.MAX_VALUE))
            .andExpect(status().isNotFound());
    }

    @Test
    @Transactional
    public void updateGta() throws Exception {
        // Initialize the database
        gtaService.save(gta);
        // As the test used the service layer, reset the Elasticsearch mock repository
        reset(mockGtaSearchRepository);

        int databaseSizeBeforeUpdate = gtaRepository.findAll().size();

        // Update the gta
        Gta updatedGta = gtaRepository.findById(gta.getId()).get();
        // Disconnect from session so that the updates on updatedGta are not directly saved in db
        em.detach(updatedGta);
        updatedGta
            .numero(UPDATED_NUMERO)
            .serie(UPDATED_SERIE)
            .ativo(UPDATED_ATIVO);

        restGtaMockMvc.perform(put("/api/gtas")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(updatedGta)))
            .andExpect(status().isOk());

        // Validate the Gta in the database
        List<Gta> gtaList = gtaRepository.findAll();
        assertThat(gtaList).hasSize(databaseSizeBeforeUpdate);
        Gta testGta = gtaList.get(gtaList.size() - 1);
        assertThat(testGta.getNumero()).isEqualTo(UPDATED_NUMERO);
        assertThat(testGta.getSerie()).isEqualTo(UPDATED_SERIE);
        assertThat(testGta.isAtivo()).isEqualTo(UPDATED_ATIVO);

        // Validate the Gta in Elasticsearch
        verify(mockGtaSearchRepository, times(1)).save(testGta);
    }

    @Test
    @Transactional
    public void updateNonExistingGta() throws Exception {
        int databaseSizeBeforeUpdate = gtaRepository.findAll().size();

        // Create the Gta

        // If the entity doesn't have an ID, it will throw BadRequestAlertException
        restGtaMockMvc.perform(put("/api/gtas")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(gta)))
            .andExpect(status().isBadRequest());

        // Validate the Gta in the database
        List<Gta> gtaList = gtaRepository.findAll();
        assertThat(gtaList).hasSize(databaseSizeBeforeUpdate);

        // Validate the Gta in Elasticsearch
        verify(mockGtaSearchRepository, times(0)).save(gta);
    }

    @Test
    @Transactional
    public void deleteGta() throws Exception {
        // Initialize the database
        gtaService.save(gta);

        int databaseSizeBeforeDelete = gtaRepository.findAll().size();

        // Get the gta
        restGtaMockMvc.perform(delete("/api/gtas/{id}", gta.getId())
            .accept(TestUtil.APPLICATION_JSON_UTF8))
            .andExpect(status().isOk());

        // Validate the database is empty
        List<Gta> gtaList = gtaRepository.findAll();
        assertThat(gtaList).hasSize(databaseSizeBeforeDelete - 1);

        // Validate the Gta in Elasticsearch
        verify(mockGtaSearchRepository, times(1)).deleteById(gta.getId());
    }

    @Test
    @Transactional
    public void searchGta() throws Exception {
        // Initialize the database
        gtaService.save(gta);
        when(mockGtaSearchRepository.search(queryStringQuery("id:" + gta.getId()), PageRequest.of(0, 20)))
            .thenReturn(new PageImpl<>(Collections.singletonList(gta), PageRequest.of(0, 1), 1));
        // Search the gta
        restGtaMockMvc.perform(get("/api/_search/gtas?query=id:" + gta.getId()))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON_UTF8_VALUE))
            .andExpect(jsonPath("$.[*].id").value(hasItem(gta.getId().intValue())))
            .andExpect(jsonPath("$.[*].numero").value(hasItem(DEFAULT_NUMERO.toString())))
            .andExpect(jsonPath("$.[*].serie").value(hasItem(DEFAULT_SERIE.toString())))
            .andExpect(jsonPath("$.[*].ativo").value(hasItem(DEFAULT_ATIVO.booleanValue())));
    }

    @Test
    @Transactional
    public void equalsVerifier() throws Exception {
        TestUtil.equalsVerifier(Gta.class);
        Gta gta1 = new Gta();
        gta1.setId(1);
        Gta gta2 = new Gta();
        gta2.setId(gta1.getId());
        assertThat(gta1).isEqualTo(gta2);
        gta2.setId(2);
        assertThat(gta1).isNotEqualTo(gta2);
        gta1.setId(null);
        assertThat(gta1).isNotEqualTo(gta2);
    }
}
