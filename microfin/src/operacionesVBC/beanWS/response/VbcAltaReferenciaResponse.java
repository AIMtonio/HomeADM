package operacionesVBC.beanWS.response;

import general.bean.BaseBeanWS;

public class VbcAltaReferenciaResponse extends BaseBeanWS{
	private String codigoRespuesta;
	private String mensajeRespuesta;
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
