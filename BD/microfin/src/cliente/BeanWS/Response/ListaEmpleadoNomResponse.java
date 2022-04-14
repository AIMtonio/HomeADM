package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ListaEmpleadoNomResponse extends BaseBeanWS {
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String listaClientes;		
	
	
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getListaClientes() {
		return listaClientes;
	}
	public void setListaClientes(String listaClientes) {
		this.listaClientes = listaClientes;
	}
	
	
	
}
