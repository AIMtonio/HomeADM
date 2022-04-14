package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ConsultaClientesRequest extends BaseBeanWS {
	private String clienteID;

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
}
