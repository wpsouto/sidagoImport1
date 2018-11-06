package com.mycompany.myapp.domain;


import javax.persistence.*;
import java.io.Serializable;
import java.math.BigInteger;

/**
 * A Gta.
 */
public class Estratificacao implements Serializable {

    private static final long serialVersionUID = 1L;

    private BigInteger femea;
    private BigInteger macho;

    public BigInteger getFemea() {
        return femea;
    }

    public void setFemea(BigInteger femea) {
        this.femea = femea;
    }

    public BigInteger getMacho() {
        return macho;
    }

    public void setMacho(BigInteger macho) {
        this.macho = macho;
    }
}
