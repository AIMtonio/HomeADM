package tarjetas.beanWS.response;

import general.bean.BaseBeanWS;

public class OperacionesTarjetaResponse extends BaseBeanWS{
	private String numeroTransaccion;
	private String saldoActualizado;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	public String getNumeroTransaccion() {
		return numeroTransaccion;
	}
	public void setNumeroTransaccion(String numeroTransaccion) {
		this.numeroTransaccion = numeroTransaccion;
	}
	public String getSaldoActualizado() {
		return saldoActualizado;
	}
	public void setSaldoActualizado(String saldoActualizado) {
		this.saldoActualizado = saldoActualizado;
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