package operacionesCRCB.beanWS.request;

public class RetiroCuentaRequest extends BaseRequestBean {

	private String cuentaAhoID;
	private String monto;
	
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

	
}
