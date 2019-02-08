package com.mycompany.myapp.domain;


import org.springframework.data.elasticsearch.core.geo.GeoPoint;

import java.io.Serializable;

public class Municipio implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;

    private String uf;

    private GeoPoint localizacao;

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

    public GeoPoint getLocalizacao() {
        return localizacao;
    }

    public void setLocalizacao(GeoPoint localizacao) {
        this.localizacao = localizacao;
    }

}
