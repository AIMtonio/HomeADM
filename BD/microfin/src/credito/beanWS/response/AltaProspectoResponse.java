package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class AltaProspectoResponse extends BaseBeanWS{
	private String prospectoID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	

	public String getProspectoID() {
		return prospectoID;
	}

	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
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

	public void setMensajeRespuesta(String mensajerespuesta) {
		this.mensajeRespuesta = mensajerespuesta;
	}
	
	
}
