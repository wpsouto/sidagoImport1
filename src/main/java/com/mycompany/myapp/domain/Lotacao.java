package com.mycompany.myapp.domain;


import javax.persistence.*;
import java.io.Serializable;

/**
 * A Gta.
 */
@Entity
@Table(name = "lotacao", schema = "rh")
public class Lotacao implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "nome")
    private String nome;

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

    public Lotacao nome(String nome) {
        this.nome = nome;
        return this;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    @Override
    public String toString() {
        return "Lotacao{" +
            "id=" + id +
            ", nome='" + nome + '\'' +
            '}';
    }
}
