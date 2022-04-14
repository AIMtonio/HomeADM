package operacionesVBC.beanWS.response;

import general.bean.BaseBeanWS;

public class VbcAltaIdentificaCteResponse extends BaseBeanWS{
	private String identificaID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getIdentificaID() {
		return identificaID;
	}
	public void setIdentificaID(String identificaID) {
		this.identificaID = identificaID;
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
