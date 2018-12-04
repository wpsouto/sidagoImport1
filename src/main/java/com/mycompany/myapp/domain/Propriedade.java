package com.mycompany.myapp.domain;


import org.springframework.data.elasticsearch.core.geo.GeoPoint;

import java.io.Serializable;

/**
 * A Gta.
 */
public class Propriedade implements Serializable {

    private static final long serialVersionUID = 1L;

    private String codigo;

    private String nomeFantasia;

    private String ie;

    private Pessoa proprietario;

    private Municipio municipio;

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNomeFantasia() {
        return nomeFantasia;
    }

    public void setNomeFantasia(String nomeFantasia) {
        this.nomeFantasia = nomeFantasia;
    }

    public String getIe() {
        return ie;
    }

    public void setIe(String ie) {
        this.ie = ie;
    }

    public Pessoa getProprietario() {
        return proprietario;
    }

    public void setProprietario(Pessoa proprietario) {
        this.proprietario = proprietario;
    }

    public Municipio getMunicipio() {
        return municipio;
    }

    public void setMunicipio(Municipio municipio) {
        this.municipio = municipio;
    }
}
