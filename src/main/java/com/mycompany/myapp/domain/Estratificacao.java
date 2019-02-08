package com.mycompany.myapp.domain;


import java.io.Serializable;
import java.math.BigInteger;

/**
 * A Gta.
 */
public class Estratificacao implements Serializable {

    private static final long serialVersionUID = 1L;

    private BigInteger femea;
    private BigInteger macho;
    private BigInteger indefinido;
    private BigInteger total;

    public BigInteger getFemea() {
        return femea;
    }

    public void setFemea(BigInteger femea) {
        this.femea = femea;
    }

    public Estratificacao femea(BigInteger femea) {
        this.femea = femea;
        return this;
    }

    public BigInteger getMacho() {
        return macho;
    }

    public void setMacho(BigInteger macho) {
        this.macho = macho;
    }

    public Estratificacao macho(BigInteger macho) {
        this.macho = macho;
        return this;
    }

    public BigInteger getIndefinido() {
        return indefinido;
    }

    public void setIndefinido(BigInteger indefinido) {
        this.indefinido = indefinido;
    }

    public BigInteger getTotal() {
        return total;
    }

    public void setTotal(BigInteger total) {
        this.total = total;
    }
}
