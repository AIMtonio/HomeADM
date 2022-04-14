package bancaEnLinea.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaSaldoAhorroBERequest extends BaseBeanWS {
	private String	cuentaAhoID;
	private String	clienteID;
	
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
	
	


}
