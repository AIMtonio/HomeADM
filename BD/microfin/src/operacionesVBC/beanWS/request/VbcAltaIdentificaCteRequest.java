package operacionesVBC.beanWS.request;

import general.bean.BaseBeanWS;

public class VbcAltaIdentificaCteRequest extends BaseBeanWS{

	private String operacionID;
	private String clienteID;
	private String identificaID;
	private String tipoIdentiID;
	private String numIdentifica;
	private String fecExIden;
	private String fecVenIden;
	
	private String usuario;
	private String clave;
	
	public String getOperacionID() {
		return operacionID;
	}
	public void setOperacionID(String operacionID) {
		this.operacionID = operacionID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getIdentificaID() {
		return identificaID;
	}
	public void setIdentificaID(String identificaID) {
		this.identificaID = identificaID;
	}
	public String getTipoIdentiID() {
		return tipoIdentiID;
	}
	public void setTipoIdentiID(String tipoIdentiID) {
		this.tipoIdentiID = tipoIdentiID;
	}
	public String getNumIdentifica() {
		return numIdentifica;
	}
	public void setNumIdentifica(String numIdentifica) {
		this.numIdentifica = numIdentifica;
	}
	public String getFecExIden() {
		return fecExIden;
	}
	public void setFecExIden(String fecExIden) {
		this.fecExIden = fecExIden;
	}
	public String getFecVenIden() {
		return fecVenIden;
	}
	public void setFecVenIden(String fecVenIden) {
		this.fecVenIden = fecVenIden;
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