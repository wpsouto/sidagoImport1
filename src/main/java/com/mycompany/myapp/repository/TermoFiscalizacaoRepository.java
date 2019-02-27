package com.mycompany.myapp.repository;

import com.mycompany.myapp.domain.TermoFiscalizacao;
import com.mycompany.myapp.service.dto.TermoFiscalizacaoDTO;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


/**
 * Spring Data  repository for the Gta entity.
 */
@SuppressWarnings("unused")
@Repository
public interface TermoFiscalizacaoRepository extends JpaRepository<TermoFiscalizacao, Integer> {


    @Query(nativeQuery = true)
    List<TermoFiscalizacaoDTO> findAllDataMapping(Pageable pageable);
}
