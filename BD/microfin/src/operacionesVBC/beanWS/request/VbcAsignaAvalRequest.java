package operacionesVBC.beanWS.request;

import general.bean.BaseBeanWS;

public class VbcAsignaAvalRequest extends BaseBeanWS{
	private String solicitudCreditoID;
	private String avalID;
	private String clienteID;
	private String fechaRegistro;
	
	private String usuario;
	private String clave;
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getAvalID() {
		return avalID;
	}
	public void setAvalID(String avalID) {
		this.avalID = avalID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
}
