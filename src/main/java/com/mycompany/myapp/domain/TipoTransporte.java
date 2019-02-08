package com.mycompany.myapp.domain;


import java.io.Serializable;

public class TipoTransporte implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;

    public String getNome() {
        return nome;
    }

    public TipoTransporte nome(String nome) {
        this.nome = nome;
        return this;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    @Override
    public String toString() {
        return "TipoTransporte{" +
            ", nome='" + nome + '\'' +
            '}';
    }
}
