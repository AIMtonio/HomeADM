package operacionesVBC.beanWS.response;

public class VbcAltaDirecClienteResponse {
	private String direccionID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	public String getDireccionID() {
		return direccionID;
	}
	public void setDireccionID(String direccionID) {
		this.direccionID = direccionID;
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