package cuentas.beanWS.request;

import general.bean.BaseBeanWS;

public class ListaCuentaAhoRequest extends BaseBeanWS{
	private String nombreCompleto;
	private String numLis;
	
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getNumLis() {
		return numLis;
	}
	public void setNumLis(String numLis) {
		this.numLis = numLis;
	}
	
}
