package bancaEnLinea.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaCargosPendientesBEResponse extends BaseBeanWS{
	
	private String listaCargos;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	
	public String getListaCargos() {
		return listaCargos;
	}
	public void setListaCargos(String listaCargos) {
		this.listaCargos = listaCargos;
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
