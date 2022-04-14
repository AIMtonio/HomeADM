package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ConsultaDireccionClientesRequest extends BaseBeanWS {

	private String clienteID;
	private String direccionID;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getDireccionID() {
		return direccionID;
	}
	public void setDireccionID(String direccionID) {
		this.direccionID = direccionID;
	}
	
}
