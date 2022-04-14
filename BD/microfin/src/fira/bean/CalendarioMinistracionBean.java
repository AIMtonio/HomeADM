package fira.bean;

import general.bean.BaseBean;

public class CalendarioMinistracionBean extends BaseBean {

	private String productoCreditoID;
	private String tomaFechaInhabil;
	private String permiteCalIrregular;
	private String diasCancelacion;
	private String diasMaxMinistraPosterior;
	private String frecuencias;
	private String plazos;
	private String tipoCancelacion;

	public String getProductoCreditoID() {
		return productoCreditoID;
	}

	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}

	public String getTomaFechaInhabil() {
		return tomaFechaInhabil;
	}

	public void setTomaFechaInhabil(String tomaFechaInhabil) {
		this.tomaFechaInhabil = tomaFechaInhabil;
	}

	public String getPermiteCalIrregular() {
		return permiteCalIrregular;
	}

	public void setPermiteCalIrregular(String permiteCalIrregular) {
		this.permiteCalIrregular = permiteCalIrregular;
	}

	public String getDiasCancelacion() {
		return diasCancelacion;
	}

	public void setDiasCancelacion(String diasCancelacion) {
		this.diasCancelacion = diasCancelacion;
	}

	public String getDiasMaxMinistraPosterior() {
		return diasMaxMinistraPosterior;
	}

	public void setDiasMaxMinistraPosterior(String diasMaxMinistraPosterior) {
		this.diasMaxMinistraPosterior = diasMaxMinistraPosterior;
	}

	public String getFrecuencias() {
		return frecuencias;
	}

	public void setFrecuencias(String frecuencias) {
		this.frecuencias = frecuencias;
	}

	public String getPlazos() {
		return plazos;
	}

	public void setPlazos(String plazos) {
		this.plazos = plazos;
	}

	public String getTipoCancelacion() {
		return tipoCancelacion;
	}

	public void setTipoCancelacion(String tipoCancelacion) {
		this.tipoCancelacion = tipoCancelacion;
	}

}