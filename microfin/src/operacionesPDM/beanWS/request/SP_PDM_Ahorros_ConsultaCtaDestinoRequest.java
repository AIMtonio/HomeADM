package operacionesPDM.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDM_Ahorros_ConsultaCtaDestinoRequest extends BaseBeanWS{
	
	private String clienteID;
	private String idUsuario;
	private String clave;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(String idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	


}
