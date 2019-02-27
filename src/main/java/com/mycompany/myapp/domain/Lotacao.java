package com.mycompany.myapp.domain;


import javax.persistence.*;
import java.io.Serializable;

/**
 * A Gta.
 */
public class Lotacao implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;

    private String nome;

    private String organograma;

    private Regional regional;

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

    public String getOrganograma() {
        return organograma;
    }

    public void setOrganograma(String organograma) {
        this.organograma = organograma;
    }

    public Regional getRegional() {
        return regional;
    }

    public void setRegional(Regional regional) {
        this.regional = regional;
    }

    @Override
    public String toString() {
        return "Lotacao{" +
            "id=" + id +
            ", nome='" + nome + '\'' +
            '}';
    }
}
