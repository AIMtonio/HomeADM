package nomina.beanWS.response;

import general.bean.BaseBeanWS;

public class RegistroPagosNominaResponse extends BaseBeanWS{
	private String folioNominaID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getFolioNominaID() {
		return folioNominaID;
	}
	public void setFolioNominaID(String folioNominaID) {
		this.folioNominaID = folioNominaID;
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
