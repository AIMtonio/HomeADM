package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaProdCredResponse extends BaseBeanWS {

	// Parametros de respuesta para ZAFY
	private String producCreditoID;
	private String tasaFija;
	private String tipoComXapert;
	private String montoComXapert;
	private String montoInferior;
	private String montoSuperior;
	private String frecuencias;
	private String plazoID;
	private String codigoRespuesta;
	private String mensajeRespuesta;

	public String getProducCreditoID() {
		return producCreditoID;
	}

	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}

	public String getTasaFija() {
		return tasaFija;
	}

	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}

	public String getTipoComXapert() {
		return tipoComXapert;
	}

	public void setTipoComXapert(String tipoComXapert) {
		this.tipoComXapert = tipoComXapert;
	}

	public String getMontoComXapert() {
		return montoComXapert;
	}

	public void setMontoComXapert(String montoComXapert) {
		this.montoComXapert = montoComXapert;
	}

	public String getMontoInferior() {
		return montoInferior;
	}

	public void setMontoInferior(String montoInferior) {
		this.montoInferior = montoInferior;
	}

	public String getMontoSuperior() {
		return montoSuperior;
	}

	public void setMontoSuperior(String montoSuperior) {
		this.montoSuperior = montoSuperior;
	}

	public String getFrecuencias() {
		return frecuencias;
	}

	public void setFrecuencias(String frecuencias) {
		this.frecuencias = frecuencias;
	}

	public String getPlazoID() {
		return plazoID;
	}

	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}

	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}

	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}

	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}

	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}

}
