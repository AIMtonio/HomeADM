package operacionesPDA.beanWS.response;

public class SP_PDA_Ahorros_ConsultaSaldoResponse {
    private String Celular;
	private String DescripTipoCuenta;
    private String SaldoDisp;
	private String codigoRespuesta;
	private String mensajeRespuesta;
    

	public String getCelular() {
		return Celular;
	}
	public void setCelular(String celular) {
		Celular = celular;
	}
	public String getDescripTipoCuenta() {
		return DescripTipoCuenta;
	}
	public void setDescripTipoCuenta(String descripTipoCuenta) {
		DescripTipoCuenta = descripTipoCuenta;
	}
	public String getSaldoDisp() {
		return SaldoDisp;
	}
	public void setSaldoDisp(String saldoDisp) {
		SaldoDisp = saldoDisp;
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
