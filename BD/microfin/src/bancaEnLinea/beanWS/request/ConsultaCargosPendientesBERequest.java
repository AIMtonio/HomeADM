package bancaEnLinea.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaCargosPendientesBERequest extends BaseBeanWS {
	
	private String clienteID;		
	private String cuentaAhoID;
	private String mes;
	private String anio;
		
	
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
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
