package operacionesCRCB.beanWS.response;

public class ActCuentaDestinoResponse extends BaseResponseBean {
	
	private String cuentaTranID;
	private String clienteID;
	
	public String getCuentaTranID() {
		return cuentaTranID;
	}
	public void setCuentaTranID(String cuentaTranID) {
		this.cuentaTranID = cuentaTranID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
	
}
