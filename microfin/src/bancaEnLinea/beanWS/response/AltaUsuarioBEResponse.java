package bancaEnLinea.beanWS.response;

import general.bean.BaseBeanWS;

public class AltaUsuarioBEResponse extends BaseBeanWS{
	private String clave;
	private String codigoRespuesta;
	private String mensajeRespuesta;

	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
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
