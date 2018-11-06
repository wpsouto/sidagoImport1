package com.mycompany.myapp.domain;


import java.io.Serializable;

/**
 * A Gta.
 */
public class InscricaoEstadual implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private String nomeFantasia;
    private String numero;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNomeFantasia() {
        return nomeFantasia;
    }

    public void setNomeFantasia(String nomeFantasia) {
        this.nomeFantasia = nomeFantasia;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }
}
