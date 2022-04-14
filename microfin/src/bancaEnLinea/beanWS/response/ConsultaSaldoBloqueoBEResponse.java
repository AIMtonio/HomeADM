package bancaEnLinea.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaSaldoBloqueoBEResponse extends BaseBeanWS{
	
	
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String listaSaldos;
	
	
	
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
	public String getListaSaldos() {
		return listaSaldos;
	}
	public void setListaSaldos(String listaSaldos) {
		this.listaSaldos = listaSaldos;
	}
	
}
