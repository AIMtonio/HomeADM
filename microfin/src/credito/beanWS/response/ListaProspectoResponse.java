package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ListaProspectoResponse extends BaseBeanWS {
	private String listaProspecto;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getListaProspecto() {
		return listaProspecto;
	}
	public void setListaProspecto(String listaProspecto) {
		this.listaProspecto = listaProspecto;
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
