package com.mycompany.myapp.domain;


import javax.persistence.*;
import java.io.Serializable;

/**
 * A Gta.
 */
public class Municipio implements Serializable {

    private static final long serialVersionUID = 1L;

    private short id;

    private String nome;

    private String uf;

    // jhipster-needle-entity-add-field - JHipster will add fields here, do not remove
    public short getId() {
        return id;
    }

    public void setId(short id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public Municipio nome(String nome) {
        this.nome = nome;
        return this;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getUf() {
        return uf;
    }

    public void setUf(String uf) {
        this.uf = uf;
    }

    @Override
    public String toString() {
        return "Municipio{" +
            "id=" + id +
            ", nome='" + nome + '\'' +
            ", uf='" + uf + '\'' +
            '}';
    }
}
