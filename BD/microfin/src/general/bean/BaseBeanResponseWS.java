package general.bean;

import java.util.Map;

public class BaseBeanResponseWS {
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String consecutivo;
	private Map<String, String> transaccion;
	
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
		System.out.println("BaseBeanResponseWS.codigoRespuesta: " + mensajeRespuesta);

		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public Map<String, String> getTransaccion() {
		return transaccion;
	}
	public void setTransaccion(Map<String, String> transaccion) {
		this.transaccion = transaccion;
	}
}
