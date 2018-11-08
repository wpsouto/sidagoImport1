package com.mycompany.myapp.repository;

import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.service.dto.GtaDTO;
import org.hibernate.annotations.NamedNativeQueries;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.persistence.SqlResultSetMapping;
import java.util.List;


/**
 * Spring Data  repository for the Gta entity.
 */
@SuppressWarnings("unused")
@Repository
public interface GtaRepository extends JpaRepository<Gta, Integer> {

/*
    @Query(value =
        "SELECT gt.id_gta AS id, " +
            "gt.nu_gta AS numero, " +
            "gt.nu_serie , " +
            "gt.bo_ativo, " +
            "CAST(gt.dados AS TEXT) AS dados, " +
            "f.id_finalidade AS finalidade_id, " +
            "f.no_finalidade AS finalidade_nome " +
            "FROM gta.gta AS gt" +
            "INNER JOIN gta.finalidade AS f ON gt.id_finalidade = f.id_finalidade",
        countQuery = "SELECT count(*) FROM gta.gta",
        nativeQuery = true)
    Page<Gta> findAll(Pageable pageable);
*/

}
