package com.mycompany.myapp.service.mapper;

import com.mycompany.myapp.domain.Gta;
import com.mycompany.myapp.service.dto.GtaDTO;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Mapper for the entity User and its DTO called UserDTO.
 *
 * Normal mappers are generated using MapStruct, this one is hand-coded as MapStruct
 * support is still in beta, and requires a manual step with an IDE.
 */
@Service
public class GtaMapper {

    public GtaDTO gtaToGtaDTO(Gta gta) {
        return new GtaDTO(gta);
    }

    public List<GtaDTO> gtasToGtaDTOs(List<Gta> gtas) {
        return gtas.stream()
            .filter(Objects::nonNull)
            .map(this::gtaToGtaDTO)
            .collect(Collectors.toList());
    }

}
