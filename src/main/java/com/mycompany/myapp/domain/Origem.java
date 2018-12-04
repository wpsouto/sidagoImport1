package com.mycompany.myapp.domain;


import java.io.Serializable;

/**
 * A Gta.
 */
public class Origem implements Serializable {

    private static final long serialVersionUID = 1L;

    private Propriedade propriedade;

    public Propriedade getPropriedade() {
        return propriedade;
    }

    public void setPropriedade(Propriedade propriedade) {
        this.propriedade = propriedade;
    }

}
