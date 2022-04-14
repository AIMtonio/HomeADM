package invkubo.beanws.response;

public class CancelarInversionResponse {
	private String porcentajeFondeo;
	private String montoFaltaFondeo;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	public String getPorcentajeFondeo() {
		return porcentajeFondeo;
	}
	public void setPorcentajeFondeo(String porcentajeFondeo) {
		this.porcentajeFondeo = porcentajeFondeo;
	}
	public String getMontoFaltaFondeo() {
		return montoFaltaFondeo;
	}
	public void setMontoFaltaFondeo(String montoFaltaFondeo) {
		this.montoFaltaFondeo = montoFaltaFondeo;
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
