package com.mycompany.myapp.service.dto;

import com.mycompany.myapp.domain.*;
import org.springframework.data.elasticsearch.annotations.Document;

import java.math.BigInteger;
import java.util.Date;

@Document(indexName = "gta", type = "doc")
public class GtaDTO {

    private Integer id;

    private String numero;

    private String serie;

    private Date emissao;

    private String dare;

    private String valor;

    private Boolean ativo;

    private Finalidade finalidade;

    private Especie especie;

    private TipoTransporte transporte;

    private Emissor emissor;

    private Origem origem;

    private Destino destino;

    private Estratificacao estratificacao;

    private String dados;

    public GtaDTO() {
        // Empty constructor needed for Jackson.
    }

    public GtaDTO(Gta gta) {
        this.id = gta.getId();
        this.numero = gta.getNumero();
        this.serie = gta.getSerie();
    }

    public GtaDTO(Integer id, String numero, Finalidade finalidade) {
        this.id = id;
        this.numero = numero;
        this.finalidade = finalidade;
    }

    public GtaDTO(Integer id, String numero, String serie, Date emissao, String dare) {
        this.id = id;
        this.numero = numero;
        this.serie = serie;
        this.emissao = emissao;
        this.dare = dare;
    }

    public GtaDTO(Integer id, String numero, String serie, Date emissao, String dare, String valor, Boolean ativo, String dados,
                  Integer finalidade_id, String finalidade_nome,
                  Integer especie_id, String especie_nome,
                  Integer transporte_id, String transporte_nome,
                  Integer emissor_id, String emissor_nome,
                  Integer emissor_lotacao_id, String emissor_lotacao_nome,
                  Integer origem_pessoa_id, String origem_pessoa_nome, String origem_pessoa_documento,
                  short origem_municipio_id, String origem_municipio_nome, String origem_municipio_uf,
                  String origem_propriedade_codigo,
                  Integer origem_inscricao_estadual_id, String origem_inscricao_estadual_nome_fantasia, String origem_inscricao_estadual_numero,
                  Integer destino_pessoa_id, String destino_pessoa_nome, String destino_pessoa_documento,
                  short destino_municipio_id, String destino_municipio_nome, String destino_municipio_uf,
                  String destino_propriedade_codigo,
                  Integer destino_inscricao_estadual_id, String destino_inscricao_estadual_nome_fantasia, String destino_inscricao_estadual_numero,
                  BigInteger estratificacoes_femea, BigInteger estratificacoes_macho) {

        this.id = id;
        this.numero = numero;
        this.serie = serie;
        this.emissao = emissao;
        this.dare = dare;
        this.valor = valor;
        this.ativo = ativo;
        this.dados = dados;

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
        this.emissor.setId(emissor_id);
        this.emissor.setNome(emissor_nome);
        this.emissor.getLotacao().setId(emissor_lotacao_id);
        this.emissor.getLotacao().setNome(emissor_lotacao_nome);

        this.origem = new Origem();
        this.origem.setPessoa(new Pessoa());
        this.origem.setMunicipio(new Municipio());
        this.origem.setPropriedade(new Propriedade());
        this.origem.setInscricaoEstadual(new InscricaoEstadual());
        this.origem.getPessoa().setId(origem_pessoa_id);
        this.origem.getPessoa().setNome(origem_pessoa_nome);
        this.origem.getPessoa().setDocumento(origem_pessoa_documento);
        this.origem.getMunicipio().setId(origem_municipio_id);
        this.origem.getMunicipio().setNome(origem_municipio_nome);
        this.origem.getMunicipio().setUf(origem_municipio_uf);
        this.origem.getPropriedade().setCodigo(origem_propriedade_codigo);
        this.origem.getInscricaoEstadual().setId(origem_inscricao_estadual_id);
        this.origem.getInscricaoEstadual().setNomeFantasia(origem_inscricao_estadual_nome_fantasia);
        this.origem.getInscricaoEstadual().setNumero(origem_inscricao_estadual_numero);

        this.destino = new Destino();
        this.destino.setPessoa(new Pessoa());
        this.destino.setMunicipio(new Municipio());
        this.destino.setPropriedade(new Propriedade());
        this.destino.setInscricaoEstadual(new InscricaoEstadual());
        this.destino.getPessoa().setId(destino_pessoa_id);
        this.destino.getPessoa().setNome(destino_pessoa_nome);
        this.destino.getPessoa().setDocumento(destino_pessoa_documento);
        this.destino.getMunicipio().setId(destino_municipio_id);
        this.destino.getMunicipio().setNome(destino_municipio_nome);
        this.destino.getMunicipio().setUf(destino_municipio_uf);
        this.destino.getPropriedade().setCodigo(destino_propriedade_codigo);
        this.destino.getInscricaoEstadual().setId(destino_inscricao_estadual_id);
        this.destino.getInscricaoEstadual().setNomeFantasia(destino_inscricao_estadual_nome_fantasia);
        this.destino.getInscricaoEstadual().setNumero(destino_inscricao_estadual_numero);

        this.estratificacao = new Estratificacao();
        this.estratificacao.setFemea(estratificacoes_femea);
        this.estratificacao.setMacho(estratificacoes_macho);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
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

    public String getValor() {
        return valor;
    }

    public void setValor(String valor) {
        this.valor = valor;
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
