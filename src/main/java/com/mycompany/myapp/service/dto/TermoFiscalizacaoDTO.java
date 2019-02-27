package com.mycompany.myapp.service.dto;

import com.mycompany.myapp.domain.*;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.core.geo.GeoPoint;

import java.math.BigDecimal;
import java.util.Date;

@Document(indexName = "termo_fiscalizacao", type = "doc")
public class TermoFiscalizacaoDTO {

    private Integer id;

    private Integer idTermoFiscalizacao;

    private Integer numero;

    private String serie;

    private Date emissao;

    private String programa;

    private String objetivo;

    private String subObjetivo;

    private String produto;

    private String subProduto;

    private BigDecimal quantidade;

    private String autuado;

    private String cancelada;

    private String caracterizacao;

    private String identificacao;

    private Fiscalizado fiscalizado;

    private Responsavel responsavel;

    private Emissor emissor;

    public TermoFiscalizacaoDTO() {
        // Empty constructor needed for Jackson.
    }

/*
    public TermoFiscalizacaoDTO(Integer idTermoFiscalizacao, Integer numero, String serie, Date emissao, String programa, String objetivo,
                                String subObjetivo, String produto, String subProduto, BigDecimal quantidade, String autuado,
                                String cancelada, String caracterizacao, String identificacao
    ) {

        this.idTermoFiscalizacao = idTermoFiscalizacao;
        this.numero = numero;
        this.serie = serie;
        this.emissao = emissao;
        this.programa = programa;
        this.objetivo = objetivo;
        this.subObjetivo = subObjetivo;
        this.produto = produto;
        this.subProduto = subProduto;
        this.quantidade = quantidade;
        this.autuado = autuado;
        this.cancelada = cancelada;
        this.caracterizacao = caracterizacao;
        this.identificacao = identificacao;
    }
*/

    public TermoFiscalizacaoDTO(Integer id, Integer idTermoFiscalizacao, Integer numero, String serie, Date emissao,
                                String programa, String objetivo, String subObjetivo, String produto, String subProduto, BigDecimal quantidade,
                                String autuado, String cancelada, String caracterizacao, String identificacao,

                                String fiscalizado_ie, String fiscalizado_nome, String fiscalizado_documento,
                                String fiscalizado_municipio_nome, String fiscalizado_municipio_uf,
                                BigDecimal fiscalizado_municipio_localizacao_latitude, BigDecimal fiscalizado_municipio_localizacao_longitude,

                                String responsavel_nome, String responsavel_documento,

                                String emissor_nome, String emissor_documento,
                                Integer emissor_lotacao_id, String emissor_lotacao_nome, String emissor_lotacao_organograma,
                                Integer emissor_lotacao_regional_id, String emissor_lotacao_regional_nome) {

        this.id = id;
        this.idTermoFiscalizacao = idTermoFiscalizacao;
        this.numero = numero;
        this.serie = serie;
        this.emissao = emissao;
        this.programa = programa;
        this.objetivo = objetivo;
        this.subObjetivo = subObjetivo;
        this.produto = produto;
        this.subProduto = subProduto;
        this.quantidade = quantidade;
        this.autuado = autuado;
        this.cancelada = cancelada;
        this.caracterizacao = caracterizacao;
        this.identificacao = identificacao;

        this.fiscalizado = new Fiscalizado();
        this.fiscalizado.setMunicipio(new Municipio());
        this.fiscalizado.setIe(fiscalizado_ie);
        this.fiscalizado.setNome(fiscalizado_nome);
        this.fiscalizado.setDocumento(fiscalizado_documento);
        this.fiscalizado.getMunicipio().setNome(fiscalizado_municipio_nome);
        this.fiscalizado.getMunicipio().setUf(fiscalizado_municipio_uf);
        this.fiscalizado.getMunicipio().setLocalizacao(new GeoPoint(fiscalizado_municipio_localizacao_latitude.doubleValue(), fiscalizado_municipio_localizacao_longitude.doubleValue()));

        this.responsavel = new Responsavel();
        this.responsavel.setNome(responsavel_nome);
        this.responsavel.setDocumento(responsavel_documento);

        this.emissor = new Emissor();
        this.emissor.setLotacao(new Lotacao());
        this.emissor.getLotacao().setRegional(new Regional());
        this.emissor.setNome(emissor_nome);
        this.emissor.setDocumento(emissor_documento);

        this.emissor.getLotacao().setId(emissor_lotacao_id);
        this.emissor.getLotacao().setNome(emissor_lotacao_nome);
        this.emissor.getLotacao().setOrganograma(emissor_lotacao_organograma);
        this.emissor.getLotacao().getRegional().setId(emissor_lotacao_regional_id);
        this.emissor.getLotacao().getRegional().setNome(emissor_lotacao_regional_nome);

    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getIdTermoFiscalizacao() {
        return idTermoFiscalizacao;
    }

    public void setIdTermoFiscalizacao(Integer idTermoFiscalizacao) {
        this.idTermoFiscalizacao = idTermoFiscalizacao;
    }

    public Integer getNumero() {
        return numero;
    }

    public void setNumero(Integer numero) {
        this.numero = numero;
    }

    public String getSerie() {
        return serie;
    }

    public void setSerie(String serie) {
        this.serie = serie;
    }

    public Date getEmissao() {
        return emissao;
    }

    public void setEmissao(Date emissao) {
        this.emissao = emissao;
    }

    public String getPrograma() {
        return programa;
    }

    public void setPrograma(String programa) {
        this.programa = programa;
    }

    public String getObjetivo() {
        return objetivo;
    }

    public void setObjetivo(String objetivo) {
        this.objetivo = objetivo;
    }

    public String getSubObjetivo() {
        return subObjetivo;
    }

    public void setSubObjetivo(String subObjetivo) {
        this.subObjetivo = subObjetivo;
    }

    public String getProduto() {
        return produto;
    }

    public void setProduto(String produto) {
        this.produto = produto;
    }

    public String getSubProduto() {
        return subProduto;
    }

    public void setSubProduto(String subProduto) {
        this.subProduto = subProduto;
    }

    public BigDecimal getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(BigDecimal quantidade) {
        this.quantidade = quantidade;
    }

    public String getAutuado() {
        return autuado;
    }

    public void setAutuado(String autuado) {
        this.autuado = autuado;
    }

    public String getCancelada() {
        return cancelada;
    }

    public void setCancelada(String cancelada) {
        this.cancelada = cancelada;
    }

    public String getCaracterizacao() {
        return caracterizacao;
    }

    public void setCaracterizacao(String caracterizacao) {
        this.caracterizacao = caracterizacao;
    }

    public String getIdentificacao() {
        return identificacao;
    }

    public void setIdentificacao(String identificacao) {
        this.identificacao = identificacao;
    }

    public Fiscalizado getFiscalizado() {
        return fiscalizado;
    }

    public void setFiscalizado(Fiscalizado fiscalizado) {
        this.fiscalizado = fiscalizado;
    }

    public Responsavel getResponsavel() {
        return responsavel;
    }

    public void setResponsavel(Responsavel responsavel) {
        this.responsavel = responsavel;
    }

    public Emissor getEmissor() {
        return emissor;
    }

    public void setEmissor(Emissor emissor) {
        this.emissor = emissor;
    }
}
