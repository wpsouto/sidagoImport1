package com.mycompany.myapp.domain;


import java.io.Serializable;

/**
 * A Gta.
 */
public class Regional implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;

    private String nome;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public Regional nome(String nome) {
        this.nome = nome;
        return this;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

}
