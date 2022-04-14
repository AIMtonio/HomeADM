package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ListaClienteRequest extends BaseBeanWS {
	private String clienteID;
	private String nombre;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	
}
	
