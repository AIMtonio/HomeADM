package originacion.bean;

import general.bean.BaseBean;

public class EsquemaSeguroBean extends BaseBean {
	private String producCreditoID;
	private String frecuencia;
	private String monto;
	
	private String frecuenciaCap;
	private String frecuenciaInt;
	
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getFrecuenciaCap() {
		return frecuenciaCap;
	}
	public void setFrecuenciaCap(String frecuenciaCap) {
		this.frecuenciaCap = frecuenciaCap;
	}
	public String getFrecuenciaInt() {
		return frecuenciaInt;
	}
	public void setFrecuenciaInt(String frecuenciaInt) {
		this.frecuenciaInt = frecuenciaInt;
	}
}
