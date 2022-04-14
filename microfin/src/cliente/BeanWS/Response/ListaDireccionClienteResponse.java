package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ListaDireccionClienteResponse extends BaseBeanWS {
	private String listaDireccion;
	
	public String getListaDireccion() {
		return listaDireccion;
	}
	public void setListaDireccion(String listaDireccion) {
		this.listaDireccion = listaDireccion;
	}
}