package com.mycompany.myapp.domain;


import com.mycompany.myapp.service.dto.GtaDTO;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;


/**
 * A Gta.
 */

@SqlResultSetMapping(
    name = "GtaDTOResult",

    classes = @ConstructorResult(
        targetClass = GtaDTO.class,
        columns = {
            @ColumnResult(name = "id"),
            @ColumnResult(name = "numero"),
            @ColumnResult(name = "serie"),
            @ColumnResult(name = "emissao"),
            @ColumnResult(name = "dare"),
            @ColumnResult(name = "valor"),
            @ColumnResult(name = "ativo"),
            @ColumnResult(name = "finalidade_id"),
            @ColumnResult(name = "finalidade_nome"),
            @ColumnResult(name = "especie_id"),
            @ColumnResult(name = "especie_nome"),
            @ColumnResult(name = "transporte_id"),
            @ColumnResult(name = "transporte_nome"),
            @ColumnResult(name = "emissor_id"),
            @ColumnResult(name = "emissor_nome"),
            @ColumnResult(name = "emissor_lotacao_id"),
            @ColumnResult(name = "emissor_lotacao_nome"),
            @ColumnResult(name = "emissor_lotacao_regional_id"),
            @ColumnResult(name = "emissor_lotacao_regional_nome"),
            @ColumnResult(name = "origem_propriedade_codigo"),
            @ColumnResult(name = "origem_propriedade_nome_fantasia"),
            @ColumnResult(name = "origem_propriedade_ie"),
            @ColumnResult(name = "origem_propriedade_proprietario_id"),
            @ColumnResult(name = "origem_propriedade_proprietario_nome"),
            @ColumnResult(name = "origem_propriedade_proprietario_documento"),
            @ColumnResult(name = "origem_propriedade_municipio_id"),
            @ColumnResult(name = "origem_propriedade_municipio_nome"),
            @ColumnResult(name = "origem_propriedade_municipio_uf"),
            @ColumnResult(name = "origem_propriedade_municipio_localizacao_latitude"),
            @ColumnResult(name = "origem_propriedade_municipio_localizacao_longitude"),
            @ColumnResult(name = "destino_propriedade_codigo"),
            @ColumnResult(name = "destino_propriedade_nome_fantasia"),
            @ColumnResult(name = "destino_propriedade_ie"),
            @ColumnResult(name = "destino_propriedade_proprietario_id"),
            @ColumnResult(name = "destino_propriedade_proprietario_nome"),
            @ColumnResult(name = "destino_propriedade_proprietario_documento"),
            @ColumnResult(name = "destino_propriedade_municipio_id"),
            @ColumnResult(name = "destino_propriedade_municipio_nome"),
            @ColumnResult(name = "destino_propriedade_municipio_uf"),
            @ColumnResult(name = "destino_propriedade_municipio_localizacao_latitude"),
            @ColumnResult(name = "destino_propriedade_municipio_localizacao_longitude"),
            @ColumnResult(name = "estratificacoes_femea"),
            @ColumnResult(name = "estratificacoes_macho")
        })
)

@Entity
@Table(name = "gta", schema = "gta")
public class Gta implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_gta")
    private Integer id;

    @Column(name = "nu_gta")
    private String numero;

    @Column(name = "nu_serie")
    private String serie;

    @Column(name = "bo_ativo")
    private Boolean ativo;

    @OneToOne()
    @JoinColumn(name = "id_finalidade")
    private Finalidade finalidade;

    @OneToOne()
    @JoinColumn(name = "id_especie")
    private Especie especie;

    @Transient
    private TipoTransporte tipoTransporte;

    @Transient
    private Pessoa emissor;

    @Transient
    private Lotacao lotacao;

    //@Column(name = "dados", columnDefinition = "json")
    @Transient
    private String dados;


    // jhipster-needle-entity-add-field - JHipster will add fields here, do not remove
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public Gta numero(String numero) {
        this.numero = numero;
        return this;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getSerie() {
        return serie;
    }

    public Gta serie(String serie) {
        this.serie = serie;
        return this;
    }

    public void setSerie(String serie) {
        this.serie = serie;
    }

    public Boolean isAtivo() {
        return ativo;
    }

    public Gta ativo(Boolean ativo) {
        this.ativo = ativo;
        return this;
    }

    public Boolean getAtivo() {
        return ativo;
    }

    public void setAtivo(Boolean ativo) {
        this.ativo = ativo;
    }

    public String getDados() {
        return dados;
    }

    public void setDados(String dados) {
        this.dados = dados;
    }
    // jhipster-needle-entity-add-getters-setters - JHipster will add getters and setters here, do not remove


    public Finalidade getFinalidade() {
        return finalidade;
    }

    public void setFinalidade(Finalidade finalidade) {
        this.finalidade = finalidade;
    }

    public TipoTransporte getTipoTransporte() {
        return tipoTransporte;
    }

    public void setTipoTransporte(TipoTransporte tipoTransporte) {
        this.tipoTransporte = tipoTransporte;
    }

    public Especie getEspecie() {
        return especie;
    }

    public void setEspecie(Especie especie) {
        this.especie = especie;
    }

    public Pessoa getEmissor() {
        return emissor;
    }

    public void setEmissor(Pessoa emissor) {
        this.emissor = emissor;
    }

    public Lotacao getLotacao() {
        return lotacao;
    }

    public void setLotacao(Lotacao lotacao) {
        this.lotacao = lotacao;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Gta gta = (Gta) o;
        if (gta.getId() == null || getId() == null) {
            return false;
        }
        return Objects.equals(getId(), gta.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(getId());
    }

    @Override
    public String toString() {
        return "Gta{" +
            "id=" + id +
            ", numero='" + numero + '\'' +
            ", serie='" + serie + '\'' +
            ", ativo=" + ativo +
            ", finalidade=" + finalidade +
            ", tipoTransporte=" + tipoTransporte +
            ", dados='" + dados + '\'' +
            '}';
    }
}
