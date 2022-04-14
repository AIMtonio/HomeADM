package operacionesPDA.beanWS.response;

public class ConsultaSaldoCreditoResponse {

	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String saldoTotal;
	private String saldoExigibleDia;
	private String proyeccion;
	private String saldoFinalPlazo;

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

	public String getSaldoTotal() {
		return saldoTotal;
	}

	public void setSaldoTotal(String saldoTotal) {
		this.saldoTotal = saldoTotal;
	}

	public String getSaldoExigibleDia() {
		return saldoExigibleDia;
	}

	public void setSaldoExigibleDia(String saldoExigibleDia) {
		this.saldoExigibleDia = saldoExigibleDia;
	}

	public String getProyeccion() {
		return proyeccion;
	}

	public void setProyeccion(String proyeccion) {
		this.proyeccion = proyeccion;
	}

	public String getSaldoFinalPlazo() {
		return saldoFinalPlazo;
	}

	public void setSaldoFinalPlazo(String saldoFinalPlazo) {
		this.saldoFinalPlazo = saldoFinalPlazo;
	}

}
