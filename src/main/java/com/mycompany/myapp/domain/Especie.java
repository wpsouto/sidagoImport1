package com.mycompany.myapp.domain;


import java.io.Serializable;

public class Especie implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;

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

    public Especie nome(String nome) {
        this.nome = nome;
        return this;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    @Override
    public String toString() {
        return "Especie{" +
            "id=" + id +
            ", nome='" + nome + '\'' +
            '}';
    }
}
