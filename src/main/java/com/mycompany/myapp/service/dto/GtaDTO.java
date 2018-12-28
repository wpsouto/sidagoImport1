package com.mycompany.myapp.service.dto;

import com.mycompany.myapp.domain.*;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.core.geo.GeoPoint;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;

@Document(indexName = "gta_temp", type = "doc")
public class GtaDTO {

    private Integer id;

    private Integer numero;

    private String serie;

    private Date emissao;

    private String dare;

    private BigDecimal valor;

    private Boolean ativo;

    private Finalidade finalidade;

    private Especie especie;

    private TipoTransporte transporte;

    private Emissor emissor;

    private Origem origem;

    private Destino destino;

    private Estratificacao estratificacao;

//    private String dados;

    public GtaDTO() {
        // Empty constructor needed for Jackson.
    }

    public GtaDTO(Integer id, Integer numero, String serie, Date emissao, String dare, BigDecimal valor, Boolean ativo,
                  Integer finalidade_id, String finalidade_nome,
                  Integer especie_id, String especie_nome,
                  Integer transporte_id, String transporte_nome,
                  Integer emissor_id, String emissor_nome,
                  Integer emissor_lotacao_id, String emissor_lotacao_nome,
                  Integer emissor_lotacao_regional_id, String emissor_lotacao_regional_nome,
                  Integer origem_propriedade_id, String origem_propriedade_codigo, String origem_propriedade_nome_fantasia, String origem_propriedade_ie,
                  Integer origem_propriedade_proprietario_id, String origem_propriedade_proprietario_nome, String origem_propriedade_proprietario_documento,
                  short origem_propriedade_municipio_id, String origem_propriedade_municipio_nome, String origem_propriedade_municipio_uf,
                  BigDecimal origem_propriedade_municipio_localizacao_latitude, BigDecimal origem_propriedade_municipio_localizacao_longitude,
                  Integer destino_propriedade_id, String destino_propriedade_codigo, String destino_propriedade_nome_fantasia, String destino_propriedade_ie,
                  Integer destino_propriedade_proprietario_id, String destino_propriedade_proprietario_nome, String destino_propriedade_proprietario_documento,
                  short destino_propriedade_municipio_id, String destino_propriedade_municipio_nome, String destino_propriedade_municipio_uf,
                  BigDecimal destino_propriedade_municipio_localizacao_latitude, BigDecimal destino_propriedade_municipio_localizacao_longitude,
                  BigInteger estratificacao_femea, BigInteger estratificacao_macho, BigInteger estratificacao_indeterminado) {

        this.id = id;
        this.numero = numero;
        this.serie = serie;
        this.emissao = emissao;
        this.dare = dare;
        this.valor = valor;
        this.ativo = ativo;

        this.finalidade = new Finalidade();
        this.finalidade.setId(finalidade_id);
        this.finalidade.setNome(finalidade_nome);

        this.especie = new Especie();
        this.especie.setId(especie_id);
        this.especie.setNome(especie_nome);

        this.transporte = new TipoTransporte();
        this.transporte.setId(transporte_id);
        this.transporte.setNome(transporte_nome);

        this.emissor = new Emissor();
        this.emissor.setLotacao(new Lotacao());
        this.emissor.getLotacao().setRegional(new Regional());
        this.emissor.setId(emissor_id);
        this.emissor.setNome(emissor_nome);
        this.emissor.getLotacao().setId(emissor_lotacao_id);
        this.emissor.getLotacao().setNome(emissor_lotacao_nome);
        this.emissor.getLotacao().getRegional().setId(emissor_lotacao_regional_id);
        this.emissor.getLotacao().getRegional().setNome(emissor_lotacao_regional_nome);

        this.origem = new Origem();
        this.origem.setPropriedade(new Propriedade());
        this.origem.getPropriedade().setProprietario(new Pessoa());
        this.origem.getPropriedade().setMunicipio(new Municipio());
        this.origem.getPropriedade().setId(origem_propriedade_id);
        this.origem.getPropriedade().setCodigo(origem_propriedade_codigo);
        this.origem.getPropriedade().setNomeFantasia(origem_propriedade_nome_fantasia);
        this.origem.getPropriedade().setIe(origem_propriedade_ie);

        this.origem.getPropriedade().getProprietario().setId(origem_propriedade_proprietario_id);
        this.origem.getPropriedade().getProprietario().setNome(origem_propriedade_proprietario_nome);
        this.origem.getPropriedade().getProprietario().setDocumento(origem_propriedade_proprietario_documento);

        this.origem.getPropriedade().getMunicipio().setId(origem_propriedade_municipio_id);
        this.origem.getPropriedade().getMunicipio().setNome(origem_propriedade_municipio_nome);
        this.origem.getPropriedade().getMunicipio().setUf(origem_propriedade_municipio_uf);
        if (origem_propriedade_municipio_localizacao_latitude != null && origem_propriedade_municipio_localizacao_longitude != null) {
            this.origem.getPropriedade().getMunicipio().setLocalizacao(new GeoPoint(origem_propriedade_municipio_localizacao_latitude.doubleValue(), origem_propriedade_municipio_localizacao_longitude.doubleValue()));
        }

        this.destino = new Destino();
        this.destino.setPropriedade(new Propriedade());
        this.destino.getPropriedade().setProprietario(new Pessoa());
        this.destino.getPropriedade().setMunicipio(new Municipio());
        this.destino.getPropriedade().setId(destino_propriedade_id);
        this.destino.getPropriedade().setCodigo(destino_propriedade_codigo);
        this.destino.getPropriedade().setNomeFantasia(destino_propriedade_nome_fantasia);
        this.destino.getPropriedade().setIe(destino_propriedade_ie);

        this.destino.getPropriedade().getProprietario().setId(destino_propriedade_proprietario_id);
        this.destino.getPropriedade().getProprietario().setNome(destino_propriedade_proprietario_nome);
        this.destino.getPropriedade().getProprietario().setDocumento(destino_propriedade_proprietario_documento);

        this.destino.getPropriedade().getMunicipio().setId(destino_propriedade_municipio_id);
        this.destino.getPropriedade().getMunicipio().setNome(destino_propriedade_municipio_nome);
        this.destino.getPropriedade().getMunicipio().setUf(destino_propriedade_municipio_uf);
        this.destino.getPropriedade().setCodigo(destino_propriedade_codigo);
        this.destino.getPropriedade().setNomeFantasia(destino_propriedade_nome_fantasia);
        this.destino.getPropriedade().setIe(destino_propriedade_ie);

        if (destino_propriedade_municipio_localizacao_latitude != null && destino_propriedade_municipio_localizacao_longitude != null) {
            this.destino.getPropriedade().getMunicipio().setLocalizacao(new GeoPoint(destino_propriedade_municipio_localizacao_latitude.doubleValue(), destino_propriedade_municipio_localizacao_longitude.doubleValue()));
        }

        this.estratificacao = new Estratificacao();
        this.estratificacao.setFemea(estratificacao_femea);
        this.estratificacao.setMacho(estratificacao_macho);
        this.estratificacao.setIndeterminado(estratificacao_indeterminado);
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

    public Boolean getAtivo() {
        return ativo;
    }

    public void setAtivo(Boolean ativo) {
        this.ativo = ativo;
    }

    /*  public String getDados() {
          return dados;
      }

      public void setDados(String dados) {
          this.dados = dados;
      }
  */
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
