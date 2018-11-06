package com.mycompany.myapp.domain;


import org.springframework.data.elasticsearch.annotations.Document;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

/**
 * A Gta.
 */
@Entity
@Table(name = "finalidade", schema = "gta")
public class Finalidade implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_finalidade")
    private Integer id;

    @Column(name = "no_finalidade")
    private String nome;

    public Finalidade() {
    }

    public Finalidade(Integer id, String nome) {
        this.id = id;
        this.nome = nome;
    }

    // jhipster-needle-entity-add-field - JHipster will add fields here, do not remove
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public Finalidade nome(String nome) {
        this.nome = nome;
        return this;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    @Override
    public String toString() {
        return "Finalidade{" +
            "id=" + id +
            ", nome='" + nome + '\'' +
            '}';
    }
}
