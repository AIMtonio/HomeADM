package invkubo.beanws.request;

public class CancelarInversionRequest {
	private String solicitudCreditoID;
	private String clienteID;
	private String cuentaAhoID;
	private String montoFondeo;
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMontoFondeo() {
		return montoFondeo;
	}
	public void setMontoFondeo(String montoFondeo) {
		this.montoFondeo = montoFondeo;
	}	
}
