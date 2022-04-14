package soporte.bean;

import general.bean.BaseBean;

public class TiposDocumentosBean extends BaseBean {
	private String tipoDocumentoID;
	private String descripcion;
	private String requeridoEn;
	private String estatus;
	/********Alertas *****/
	private String sucursal;
	private String usuario;
	private String clienteID;

	
	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}
	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getRequeridoEn() {
		return requeridoEn;
	}
	public void setRequeridoEn(String requeridoEn) {
		this.requeridoEn = requeridoEn;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
}
