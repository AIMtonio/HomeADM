package pld.bean;

import general.bean.BaseBean;

public class NivelRiesgoClienteBean extends BaseBean {

	private String operProcesoID;

	private String codigoMatriz;
	private String conceptoMatrizID;
	private String concepto;
	private String descripcion;
	private String valor;
	private String limiteValida;

	/* Valores de riesgo */
	private String pepNacional;
	private String pepExtranjero;
	private String localidad;
	private String actEconomica;
	private String origenRecursos;
	private String prodCredito;
	private String destCredito;
	private String liAlertInusualesMesVal;
	private String liOperRelevMesVal;
	
	/* Valores resultado de la evaluacion */
	private String cumple;
	private String puntajeTotal;
	private String puntajeObtenido;
	private String porcentaje;
	private String nivelRiesgo;
	private String tipoProceso;

	private String clienteID;

	/* Atributos para reportes */
	private String nomInstitucion;
	private String nomUsuario;
	private String fechaEmision;
	private String nomSucursal;
	private String fechaInicio;
	private String fechaFin;
	private String nombreCliente;
	private String porcentajeAnterior;
	private String nivelAnterior;
	private String fechaEvaluacion;
	private String fechaSistema;

	public String getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public String getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getNomInstitucion() {
		return nomInstitucion;
	}

	public void setNomInstitucion(String nomInstitucion) {
		this.nomInstitucion = nomInstitucion;
	}

	public String getNomUsuario() {
		return nomUsuario;
	}

	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}

	public String getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public String getNomSucursal() {
		return nomSucursal;
	}

	public void setNomSucursal(String nomSucursal) {
		this.nomSucursal = nomSucursal;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getTipoProceso() {
		return tipoProceso;
	}

	public void setTipoProceso(String tipoProceso) {
		this.tipoProceso = tipoProceso;
	}

	public String getOperProcesoID() {
		return operProcesoID;
	}

	public void setOperProcesoID(String operProcesoID) {
		this.operProcesoID = operProcesoID;
	}

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

	public String getLiOperRelevMesVal() {
		return liOperRelevMesVal;
	}

	public void setLiOperRelevMesVal(String liOperRelevMesVal) {
		this.liOperRelevMesVal = liOperRelevMesVal;
	}

	public String getCumple() {
		return cumple;
	}

	public void setCumple(String cumple) {
		this.cumple = cumple;
	}

	public String getPuntajeTotal() {
		return puntajeTotal;
	}

	public void setPuntajeTotal(String puntajeTotal) {
		this.puntajeTotal = puntajeTotal;
	}

	public String getPuntajeObtenido() {
		return puntajeObtenido;
	}

	public void setPuntajeObtenido(String puntajeObtenido) {
		this.puntajeObtenido = puntajeObtenido;
	}

	public String getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}

	public String getNivelRiesgo() {
		return nivelRiesgo;
	}

	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}

	public String getNombreCliente() {
		return nombreCliente;
	}

	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}

	public String getPorcentajeAnterior() {
		return porcentajeAnterior;
	}

	public void setPorcentajeAnterior(String porcentajeAnterior) {
		this.porcentajeAnterior = porcentajeAnterior;
	}

	public String getNivelAnterior() {
		return nivelAnterior;
	}

	public void setNivelAnterior(String nivelAnterior) {
		this.nivelAnterior = nivelAnterior;
	}

	public String getFechaEvaluacion() {
		return fechaEvaluacion;
	}

	public void setFechaEvaluacion(String fechaEvaluacion) {
		this.fechaEvaluacion = fechaEvaluacion;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	
}