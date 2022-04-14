package cuentas.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaCuentasPorClienteRequest extends BaseBeanWS{
	private String clienteID;
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
}
