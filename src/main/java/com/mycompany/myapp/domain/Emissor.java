package com.mycompany.myapp.domain;


import javax.persistence.*;
import java.io.Serializable;

/**
 * A Gta.
 */
public class Emissor implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;

    private String documento;

    private Lotacao lotacao;

    public String getNome() {
        return nome;
    }

    public Emissor nome(String nome) {
        this.nome = nome;
        return this;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public Lotacao getLotacao() {
        return lotacao;
    }

    public void setLotacao(Lotacao lotacao) {
        this.lotacao = lotacao;
    }
}
