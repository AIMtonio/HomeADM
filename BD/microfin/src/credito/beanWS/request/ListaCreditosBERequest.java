package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ListaCreditosBERequest extends BaseBeanWS {
	
	private String clienteID;

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
	

}
