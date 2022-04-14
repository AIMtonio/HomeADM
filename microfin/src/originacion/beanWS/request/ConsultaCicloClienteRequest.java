package originacion.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaCicloClienteRequest extends BaseBeanWS{
	private String clienteID;
    private String prospectoID;
    
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
    
    
	

}
