package pld.bean;

import general.bean.BaseBean;

public class MatrizRiesgoBean extends BaseBean {

	private String codigoMatriz;
	private String conceptoMatrizID;
	private String concepto;
	private String descripcion;
	private String valor;
	private String limiteValida;
	private String fechaEvaluar;
	private String tipoCliente;

	/* Valores de riesgo */
	private String pepNacional;
	private String pepExtranjero;
	private String localidad;
	private String actEconomica;
	private String origenRecursos;
	private String prodCredito;
	private String destCredito;
	private String liAlertInusualesMesVal;
	private String liAlertInusualesMesLimite;
	private String liOperRelevMesVal;
	private String liOperRelevMesLimite;
	private String paisNacimiento;
	private String paisResidencia;

	public String getCodigoMatriz() {
		return codigoMatriz;
	}

	public void setCodigoMatriz(String codigoMatriz) {
		this.codigoMatriz = codigoMatriz;
	}

	public String getConceptoMatrizID() {
		return conceptoMatrizID;
	}

	public void setConceptoMatrizID(String conceptoMatrizID) {
		this.conceptoMatrizID = conceptoMatrizID;
	}

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

	public String getLimiteValida() {
		return limiteValida;
	}

	public void setLimiteValida(String limiteValida) {
		this.limiteValida = limiteValida;
	}

	public String getPepNacional() {
		return pepNacional;
	}

	public void setPepNacional(String pepNacional) {
		this.pepNacional = pepNacional;
	}

	public String getPepExtranjero() {
		return pepExtranjero;
	}

	public void setPepExtranjero(String pepExtranjero) {
		this.pepExtranjero = pepExtranjero;
	}

	public String getLocalidad() {
		return localidad;
	}

	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	public String getActEconomica() {
		return actEconomica;
	}

	public void setActEconomica(String actEconomica) {
		this.actEconomica = actEconomica;
	}

	public String getOrigenRecursos() {
		return origenRecursos;
	}

	public void setOrigenRecursos(String origenRecursos) {
		this.origenRecursos = origenRecursos;
	}

	public String getProdCredito() {
		return prodCredito;
	}

	public void setProdCredito(String prodCredito) {
		this.prodCredito = prodCredito;
	}

	public String getDestCredito() {
		return destCredito;
	}

	public void setDestCredito(String destCredito) {
		this.destCredito = destCredito;
	}

	public String getLiAlertInusualesMesVal() {
		return liAlertInusualesMesVal;
	}

	public void setLiAlertInusualesMesVal(String liAlertInusualesMesVal) {
		this.liAlertInusualesMesVal = liAlertInusualesMesVal;
	}

	public String getLiAlertInusualesMesLimite() {
		return liAlertInusualesMesLimite;
	}

	public void setLiAlertInusualesMesLimite(String liAlertInusualesMesLimite) {
		this.liAlertInusualesMesLimite = liAlertInusualesMesLimite;
	}

	public String getLiOperRelevMesVal() {
		return liOperRelevMesVal;
	}

	public void setLiOperRelevMesVal(String liOperRelevMesVal) {
		this.liOperRelevMesVal = liOperRelevMesVal;
	}

	public String getLiOperRelevMesLimite() {
		return liOperRelevMesLimite;
	}

	public void setLiOperRelevMesLimite(String liOperRelevMesLimite) {
		this.liOperRelevMesLimite = liOperRelevMesLimite;
	}

	public String getFechaEvaluar() {
		return fechaEvaluar;
	}

	public void setFechaEvaluar(String fechaEvaluar) {
		this.fechaEvaluar = fechaEvaluar;
	}

	public String getTipoCliente() {
		return tipoCliente;
	}

	public void setTipoCliente(String tipoCliente) {
		this.tipoCliente = tipoCliente;
	}

	public String getPaisNacimiento() {
		return paisNacimiento;
	}

	public void setPaisNacimiento(String paisNacimiento) {
		this.paisNacimiento = paisNacimiento;
	}

	public String getPaisResidencia() {
		return paisResidencia;
	}

	public void setPaisResidencia(String paisResidencia) {
		this.paisResidencia = paisResidencia;
	}

}