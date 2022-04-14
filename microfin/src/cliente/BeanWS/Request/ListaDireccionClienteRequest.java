package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ListaDireccionClienteRequest extends BaseBeanWS {
	private String clienteID;
	private String numLis;

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getNumLis() {
		return numLis;
	}

	public void setNumLis(String numLis) {
		this.numLis = numLis;
	}
	
}
