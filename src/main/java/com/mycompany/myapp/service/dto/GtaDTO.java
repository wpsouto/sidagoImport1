package com.mycompany.myapp.service.dto;

import com.mycompany.myapp.domain.*;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.core.geo.GeoPoint;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;

@Document(indexName = "gta")
public class GtaDTO {

    private Integer id;

    private Integer numero;

    private String serie;

    private Date emissao;

    private String dare;

    private BigDecimal valor;

    private String cancelada;

    private String organograma;

    private Finalidade finalidade;

    private Especie especie;

    private TipoTransporte transporte;

    private Emissor emissor;

    private Origem origem;

    private Destino destino;

    private Estratificacao estratificacao;

    public GtaDTO() {
        // Empty constructor needed for Jackson.
    }

    public GtaDTO(Integer id, Integer numero, String serie, Date emissao, String dare, BigDecimal valor, String cancelada, String organograma,
                  Integer finalidade_id, String finalidade_nome,
                  Integer especie_id, String especie_nome,
                  String transporte_nome,
                  String emissor_nome, String emissor_documento,
                  Integer emissor_lotacao_id, String emissor_lotacao_nome,
                  Integer emissor_lotacao_regional_id, String emissor_lotacao_regional_nome,
                  String origem_tipo,
                  String origem_estabelecimento_codigo, String origem_estabelecimento_nome_fantasia, String origem_estabelecimento_razao_social, String origem_estabelecimento_ie,
                  String origem_estabelecimento_proprietario_documento,
                  String origem_municipio_nome, String origem_municipio_uf,
                  BigDecimal origem_municipio_localizacao_latitude, BigDecimal origem_municipio_localizacao_longitude,
                  String destino_tipo,
                  String destino_estabelecimento_codigo, String destino_estabelecimento_nome_fantasia, String destino_estabelecimento_razao_social, String destino_estabelecimento_ie,
                  String destino_estabelecimento_proprietario_documento,
                  String destino_municipio_nome, String destino_municipio_uf,
                  BigDecimal destino_municipio_localizacao_latitude, BigDecimal destino_municipio_localizacao_longitude,
                  BigInteger estratificacao_femea, BigInteger estratificacao_macho, BigInteger estratificacao_indefinido, BigInteger estratificacao_total) {

        this.id = id;
        this.numero = numero;
        this.serie = serie;
        this.emissao = emissao;
        this.dare = dare;
        this.valor = valor;
        this.cancelada = cancelada;
        this.organograma = organograma;

        this.finalidade = new Finalidade();
        this.finalidade.setId(finalidade_id);
        this.finalidade.setNome(finalidade_nome);

        this.especie = new Especie();
        this.especie.setId(especie_id);
        this.especie.setNome(especie_nome);

        this.transporte = new TipoTransporte();
        //this.transporte.setId(transporte_id);
        this.transporte.setNome(transporte_nome);

        this.emissor = new Emissor();
        this.emissor.setLotacao(new Lotacao());
        this.emissor.getLotacao().setRegional(new Regional());
        //this.emissor.setId(emissor_id);
        this.emissor.setNome(emissor_nome);
        this.emissor.setDocumento(emissor_documento);
        this.emissor.getLotacao().setId(emissor_lotacao_id);
        this.emissor.getLotacao().setNome(emissor_lotacao_nome);
        this.emissor.getLotacao().getRegional().setId(emissor_lotacao_regional_id);
        this.emissor.getLotacao().getRegional().setNome(emissor_lotacao_regional_nome);

        this.origem = new Origem();
        this.origem.setEstabelecimento(new Estabelecimento());
        this.origem.getEstabelecimento().setProprietario(new Pessoa());
        this.origem.setMunicipio(new Municipio());
        this.origem.setTipo(origem_tipo);
        this.origem.getEstabelecimento().setCodigo(origem_estabelecimento_codigo);
        this.origem.getEstabelecimento().setNomeFantasia(origem_estabelecimento_nome_fantasia);
        this.origem.getEstabelecimento().setRazaoSocial(origem_estabelecimento_razao_social);
        this.origem.getEstabelecimento().setIe(origem_estabelecimento_ie);

        this.origem.getEstabelecimento().getProprietario().setDocumento(origem_estabelecimento_proprietario_documento);

        //this.origem.getMunicipio().setId(origem_municipio_id);
        this.origem.getMunicipio().setNome(origem_municipio_nome);
        this.origem.getMunicipio().setUf(origem_municipio_uf);
        this.origem.getMunicipio().setLocalizacao(new GeoPoint(origem_municipio_localizacao_latitude.doubleValue(), origem_municipio_localizacao_longitude.doubleValue()));

        this.destino = new Destino();
        this.destino.setEstabelecimento(new Estabelecimento());
        this.destino.getEstabelecimento().setProprietario(new Pessoa());
        this.destino.setMunicipio(new Municipio());
        this.destino.setTipo(destino_tipo);
        this.destino.getEstabelecimento().setCodigo(destino_estabelecimento_codigo);
        this.destino.getEstabelecimento().setNomeFantasia(destino_estabelecimento_nome_fantasia);
        this.destino.getEstabelecimento().setRazaoSocial(destino_estabelecimento_razao_social);
        this.destino.getEstabelecimento().setIe(destino_estabelecimento_ie);

        this.destino.getEstabelecimento().getProprietario().setDocumento(destino_estabelecimento_proprietario_documento);

        //this.destino.getMunicipio().setId(destino_municipio_id);
        this.destino.getMunicipio().setNome(destino_municipio_nome);
        this.destino.getMunicipio().setUf(destino_municipio_uf);
        this.destino.getMunicipio().setLocalizacao(new GeoPoint(destino_municipio_localizacao_latitude.doubleValue(), destino_municipio_localizacao_longitude.doubleValue()));

        this.estratificacao = new Estratificacao();
        this.estratificacao.setFemea(estratificacao_femea);
        this.estratificacao.setMacho(estratificacao_macho);
        this.estratificacao.setIndefinido(estratificacao_indefinido);
        this.estratificacao.setTotal(estratificacao_total);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public String getDare() {
        return dare;
    }

    public void setDare(String dare) {
        this.dare = dare;
    }

    public BigDecimal getValor() {
        return valor;
    }

    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }

    public String getCancelada() {
        return cancelada;
    }

    public void setCancelada(String cancelada) {
        this.cancelada = cancelada;
    }

    public String getOrganograma() {
        return organograma;
    }

    public void setOrganograma(String organograma) {
        this.organograma = organograma;
    }

    public Finalidade getFinalidade() {
        return finalidade;
    }

    public void setFinalidade(Finalidade finalidade) {
        this.finalidade = finalidade;
    }

    public Especie getEspecie() {
        return especie;
    }

    public void setEspecie(Especie especie) {
        this.especie = especie;
    }

    public TipoTransporte getTransporte() {
        return transporte;
    }

    public void setTransporte(TipoTransporte transporte) {
        this.transporte = transporte;
    }

    public Emissor getEmissor() {
        return emissor;
    }

    public void setEmissor(Emissor emissor) {
        this.emissor = emissor;
    }

    public Origem getOrigem() {
        return origem;
    }

    public void setOrigem(Origem origem) {
        this.origem = origem;
    }

    public Destino getDestino() {
        return destino;
    }

    public void setDestino(Destino destino) {
        this.destino = destino;
    }

    public Estratificacao getEstratificacao() {
        return estratificacao;
    }

    public void setEstratificacao(Estratificacao estratificacao) {
        this.estratificacao = estratificacao;
    }


}
