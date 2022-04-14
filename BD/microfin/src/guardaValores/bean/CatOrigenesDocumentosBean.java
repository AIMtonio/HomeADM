package guardaValores.bean;

import general.bean.BaseBean;

public class CatOrigenesDocumentosBean extends BaseBean {

	private String catOrigenDocumentoID;
	private String nombreOrigen;
	private String descripcion;
	private String estatus;

	public String getCatOrigenDocumentoID() {
		return catOrigenDocumentoID;
	}
	public void setCatOrigenDocumentoID(String catOrigenDocumentoID) {
		this.catOrigenDocumentoID = catOrigenDocumentoID;
	}
	public String getNombreOrigen() {
		return nombreOrigen;
	}
	public void setNombreOrigen(String nombreOrigen) {
		this.nombreOrigen = nombreOrigen;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

}
