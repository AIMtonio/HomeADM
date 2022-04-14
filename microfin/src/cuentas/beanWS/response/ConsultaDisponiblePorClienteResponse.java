package cuentas.beanWS.response;

public class ConsultaDisponiblePorClienteResponse {
	private String saldoDispon;
	private String codigoRespuesta;
	private String mensajeRespuesta;

	public String getSaldoDispon() {
		return saldoDispon;
	}

	public void setSaldoDispon(String saldoDispon) {
		this.saldoDispon = saldoDispon;
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
