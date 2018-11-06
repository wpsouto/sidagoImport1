package com.mycompany.myapp.domain;


import com.mycompany.myapp.service.dto.GtaDTO;
import org.springframework.data.elasticsearch.annotations.Document;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

/**
 * A Gta.
 */

@SqlResultSetMapping(
    name = "findAllDataMapping",

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
            @ColumnResult(name = "dados"),
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
            @ColumnResult(name = "origem_pessoa_id"),
            @ColumnResult(name = "origem_pessoa_nome"),
            @ColumnResult(name = "origem_pessoa_documento"),
            @ColumnResult(name = "origem_municipio_id"),
            @ColumnResult(name = "origem_municipio_nome"),
            @ColumnResult(name = "origem_municipio_uf"),
            @ColumnResult(name = "origem_propriedade_codigo"),
            @ColumnResult(name = "origem_inscricao_estadual_id"),
            @ColumnResult(name = "origem_inscricao_estadual_nome_fantasia"),
            @ColumnResult(name = "origem_inscricao_estadual_numero"),
            @ColumnResult(name = "destino_pessoa_id"),
            @ColumnResult(name = "destino_pessoa_nome"),
            @ColumnResult(name = "destino_pessoa_documento"),
            @ColumnResult(name = "destino_municipio_id"),
            @ColumnResult(name = "destino_municipio_nome"),
            @ColumnResult(name = "destino_municipio_uf"),
            @ColumnResult(name = "destino_propriedade_codigo"),
            @ColumnResult(name = "destino_inscricao_estadual_id"),
            @ColumnResult(name = "destino_inscricao_estadual_nome_fantasia"),
            @ColumnResult(name = "destino_inscricao_estadual_numero"),
            @ColumnResult(name = "estratificacoes_femea"),
            @ColumnResult(name = "estratificacoes_macho")
        })

)

@NamedNativeQuery(
    name = "findAllDataMapping",
    resultClass = GtaDTO.class,
    resultSetMapping = "findAllDataMapping",
    query =
            "SELECT gt.id_gta                                   AS id,                                                               "+
            "       gt.nu_gta                                   AS numero,                                                           "+
            "       gt.nu_serie                                 AS serie,                                                            "+
            "       gt.ts_emissao                               AS emissao,                                                          "+
            "       gr.ids_boleto                               AS dare,                                                             "+
            "       gr.vl_gta                                   AS valor,                                                            "+
            "       gt.bo_ativo                                 AS ativo,                                                            "+
            "       CAST(gt.dados AS TEXT)                      AS dados,                                                            "+
            "                                                                                                                        "+
            "       f.id_finalidade                             AS finalidade_id,                                                    "+
            "       f.no_finalidade                             AS finalidade_nome,                                                  "+
            "                                                                                                                        "+
            "       es.id                                       AS especie_id,                                                       "+
            "       es.no_especie                               AS especie_nome,                                                     "+
            "                                                                                                                        "+
            "       tt.id_tipotransporte                        AS transporte_id,                                                    "+
            "       tt.no_tipotransporte                        AS transporte_nome,                                                  "+
            "                                                                                                                        "+
            "       pe.id                                       AS emissor_id,                                                       "+
            "       pe.nome                                     AS emissor_nome,                                                     "+
            "       lote.id                                     AS emissor_lotacao_id,                                               "+
            "       lote.nome                                   AS emissor_lotacao_nome,                                             "+
            "                                                                                                                        "+
            "       po.id                                       AS origem_pessoa_id,                                                 "+
            "       po.nome                                     AS origem_pessoa_nome,                                               "+
            "       dco.numero                                  AS origem_pessoa_documento,                                          "+
            "       lo.loc_nu                                   AS origem_municipio_id,                                              "+
            "       lo.loc_no                                   AS origem_municipio_nome,                                            "+
            "       lo.ufe_sg                                   AS origem_municipio_uf,                                              "+
            "       pro.nu_codigoanimal                         AS origem_propriedade_codigo,                                        "+
            "       ieo.id_inscricaoestadual                    AS origem_inscricao_estadual_id,                                     "+
            "       ieo.no_fantasia                             AS origem_inscricao_estadual_nome_fantasia,                          "+
            "       ieo.nu_inscricaoestadual                    AS origem_inscricao_estadual_numero,                                 "+
            "                                                                                                                        "+
            "       pd.id                                       AS destino_pessoa_id,                                                "+
            "       pd.nome                                     AS destino_pessoa_nome,                                              "+
            "       dcd.numero                                  AS destino_pessoa_documento,                                         "+
            "       ld.loc_nu                                   AS destino_municipio_id,                                             "+
            "       ld.ufe_sg                                   AS destino_municipio_uf,                                             "+
            "       ld.loc_no                                   AS destino_municipio_nome,                                           "+
            "       prd.nu_codigoanimal                         AS destino_propriedade_codigo,                                       "+
            "       ied.id_inscricaoestadual                    AS destino_inscricao_estadual_id,                                    "+
            "       ied.no_fantasia                             AS destino_inscricao_estadual_nome_fantasia,                         "+
            "       ied.nu_inscricaoestadual                    AS destino_inscricao_estadual_numero,                                "+
            "                                                                                                                        "+
            "       (SELECT COALESCE(SUM(gem.nu_quantidade), 0)                                                                      "+
            "        FROM gta.estratificacao_gta AS gem                                                                              "+
            "               INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id                                     "+
            "        WHERE gem.id_gta = gt.id_gta                                                                                    "+
            "          AND em.tp_sexo = 'FE')                   AS estratificacoes_femea,                                            "+
            "       (SELECT COALESCE(SUM(gem.nu_quantidade), 0)                                                                      "+
            "        FROM gta.estratificacao_gta AS gem                                                                              "+
            "               INNER JOIN dsa.estratificacao AS em ON gem.id_estratificacao = em.id                                     "+
            "        WHERE gem.id_gta = gt.id_gta                                                                                    "+
            "          AND em.tp_sexo = 'MA')                   AS estratificacoes_macho                                             "+
            "FROM gta.gta AS gt                                                                                                      "+
            "       INNER JOIN gta.gta_origem AS gto ON gt.id_gta = gto.id_gta                                                       "+
            "       INNER JOIN gta.gta_destino AS gtd ON gt.id_gta = gtd.id_gta                                                      "+
            "       INNER JOIN gta.finalidade AS f ON gt.id_finalidade = f.id_finalidade                                             "+
            "       INNER JOIN gta.tipo_transporte AS tt ON gt.id_tipotransporte = tt.id_tipotransporte                              "+
            "       LEFT JOIN agrocomum.inscricaoestadual AS ieo ON gto.id_origem = ieo.id_inscricaoestadual                         "+
            "       LEFT JOIN agrocomum.inscricaoestadual AS ied ON gtd.id_destino = ied.id_inscricaoestadual                        "+
            "       LEFT JOIN agrocomum.propriedade AS pro ON ieo.id_inscricaoestadual = pro.id_inscricaoestadual                    "+
            "       LEFT JOIN agrocomum.propriedade AS prd ON ied.id_inscricaoestadual = prd.id_inscricaoestadual                    "+
            "       LEFT JOIN rh.documento AS dco ON ieo.id_pessoa = dco.id_pessoa and dco.id_documento_tipo in (1, 2)               "+
            "       LEFT JOIN rh.documento AS dcd ON ied.id_pessoa = dcd.id_pessoa and dcd.id_documento_tipo in (1, 2)               "+
            "       LEFT JOIN rh.pessoa AS po ON ieo.id_pessoa = po.id                                                               "+
            "       LEFT JOIN rh.pessoa AS pd ON ied.id_pessoa = pd.id                                                               "+
            "       INNER JOIN dne.log_localidade AS lo ON gto.id_municipio = lo.loc_nu                                              "+
            "       INNER JOIN dne.log_localidade AS ld ON gtd.id_municipio = ld.loc_nu                                              "+
            "       INNER JOIN rh.pessoa AS pe ON gt.id_emissor = pe.id                                                              "+
            "       INNER JOIN dsa.especie AS es ON gt.id_especie = es.id                                                            "+
            "       INNER JOIN gta.gta_rascunho AS gr ON gt.id_gta_rascunho = gr.id_gta_rascunho                                     "+
            "       INNER JOIN rh.lotacao AS lote ON gt.id_lotacao_emissor = lote.id                                                 "+
            " ORDER BY gt.id_gta                                                                                                     "

)

@Entity
@Table(name = "gta", schema = "gta")
@Document(indexName = "gta1")
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

    @OneToOne()
    @JoinColumn(name = "id_tipotransporte")
    private TipoTransporte tipoTransporte;

    @Transient
    private Pessoa emissor;

    @OneToOne()
    @JoinColumn(name = "id_lotacao_emissor")
    private Lotacao lotacao;

    @Column(name = "dados", columnDefinition = "json")
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
