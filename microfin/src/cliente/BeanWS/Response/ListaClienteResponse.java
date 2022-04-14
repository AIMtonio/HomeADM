package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ListaClienteResponse extends BaseBeanWS{
	private String listaCliente;
	
	public String getListaCliente() {
		return listaCliente;
	}
	public void setListaCliente(String listaCliente) {
		this.listaCliente = listaCliente;

	}	
	
}
