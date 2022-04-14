package operacionesCRCB.beanWS.request;

public class AbonoCuentaRequest extends BaseRequestBean {

	private String cuentaAhoID;
	private String monto;
	private String referencia;
	private String codigoRastreo;
	
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getCodigoRastreo() {
		return codigoRastreo;
	}
	public void setCodigoRastreo(String codigoRastreo) {
		this.codigoRastreo = codigoRastreo;
	}
	
}
