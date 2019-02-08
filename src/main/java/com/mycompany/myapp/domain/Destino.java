package com.mycompany.myapp.domain;


import java.io.Serializable;

/**
 * A Gta.
 */
public class Destino implements Serializable {

    private static final long serialVersionUID = 1L;

    private String tipo;

    private Estabelecimento estabelecimento;

    private Municipio municipio;

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public Estabelecimento getEstabelecimento() {
        return estabelecimento;
    }

    public void setEstabelecimento(Estabelecimento estabelecimento) {
        this.estabelecimento = estabelecimento;
    }

    public Municipio getMunicipio() {
        return municipio;
    }

    public void setMunicipio(Municipio municipio) {
        this.municipio = municipio;
    }
}
