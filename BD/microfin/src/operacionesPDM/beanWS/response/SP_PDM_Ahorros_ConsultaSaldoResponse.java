package operacionesPDM.beanWS.response;

public class SP_PDM_Ahorros_ConsultaSaldoResponse {
	
	private String celular;
	private String descripTipoCuenta;
    private String saldoDisp;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getCelular() {
		return celular;
	}
	public void setCelular(String celular) {
		this.celular = celular;
	}
	public String getDescripTipoCuenta() {
		return descripTipoCuenta;
	}
	public void setDescripTipoCuenta(String descripTipoCuenta) {
		this.descripTipoCuenta = descripTipoCuenta;
	}
	public String getSaldoDisp() {
		return saldoDisp;
	}
	public void setSaldoDisp(String saldoDisp) {
		this.saldoDisp = saldoDisp;
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
