package cuentas.beanWS.response;

public class ConsultaDisponibleCtaResponse {
	private String cuentaAhoID;
	private String saldoDispon;
	private String descripcion;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getSaldoDispon() {
		return saldoDispon;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setSaldoDispon(String saldoDispon) {
		this.saldoDispon = saldoDispon;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
    public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	

}
