package cuentas.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaSaldoAhorroHisRequest extends BaseBeanWS{
	
	private String	cuentaAhoID;
	private String	clienteID;
	private String	mes;
	private String	anio;
	
	
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	
	

}
