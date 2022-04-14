package psl.rest;

import psl.beanresponse.TransaccionBean;

public class BaseBeanResponse {
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String consecutivo;
	private TransaccionBean transaccion;

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
	public TransaccionBean getTransaccion() {
		return transaccion;
	}

	public void setTransaccion(TransaccionBean transaccion) {
		this.transaccion = transaccion;
	}
}
