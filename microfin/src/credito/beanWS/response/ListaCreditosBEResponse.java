package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ListaCreditosBEResponse extends BaseBeanWS {
	
	private String listaCreditos;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getListaCreditos() {
		return listaCreditos;
	}
	public void setListaCreditos(String listaCreditos) {
		this.listaCreditos = listaCreditos;
	}
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
	
	

}
