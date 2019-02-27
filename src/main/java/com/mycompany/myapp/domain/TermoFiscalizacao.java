package com.mycompany.myapp.domain;


import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "termo_fiscalizacao", schema = "fisc")
public class TermoFiscalizacao implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_termofiscalizacao")
    private Integer id;

    // jhipster-needle-entity-add-field - JHipster will add fields here, do not remove
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

}
