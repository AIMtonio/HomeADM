package soporte.beanWS.response;

import general.bean.MensajeTransaccionBean;

public class TimbradoRetencionResponse extends MensajeTransaccionBean {
	private String xmlTimbrado;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String consecutivo;

	public String getXmlTimbrado() {
		return xmlTimbrado;
	}
	public void setXmlTimbrado(String xmlTimbrado) {
		this.xmlTimbrado = xmlTimbrado;
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
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
}
