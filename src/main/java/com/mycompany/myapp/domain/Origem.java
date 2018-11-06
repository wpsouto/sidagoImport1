package com.mycompany.myapp.domain;


import java.io.Serializable;

/**
 * A Gta.
 */
public class Origem implements Serializable {

    private static final long serialVersionUID = 1L;

    private Pessoa pessoa;

    private Municipio municipio;

    private  Propriedade propriedade;

    private InscricaoEstadual inscricaoEstadual;

    public Pessoa getPessoa() {
        return pessoa;
    }

    public void setPessoa(Pessoa pessoa) {
        this.pessoa = pessoa;
    }

    public Municipio getMunicipio() {
        return municipio;
    }

    public void setMunicipio(Municipio municipio) {
        this.municipio = municipio;
    }

    public Propriedade getPropriedade() {
        return propriedade;
    }

    public void setPropriedade(Propriedade propriedade) {
        this.propriedade = propriedade;
    }

    public InscricaoEstadual getInscricaoEstadual() {
        return inscricaoEstadual;
    }

    public void setInscricaoEstadual(InscricaoEstadual inscricaoEstadual) {
        this.inscricaoEstadual = inscricaoEstadual;
    }
}
