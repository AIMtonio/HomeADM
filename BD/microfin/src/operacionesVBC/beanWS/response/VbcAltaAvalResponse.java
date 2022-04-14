package operacionesVBC.beanWS.response;

import general.bean.BaseBeanWS;

public class VbcAltaAvalResponse extends BaseBeanWS{
	private String avalID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getAvalID() {
		return avalID;
	}
	public void setAvalID(String avalID) {
		this.avalID = avalID;
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
