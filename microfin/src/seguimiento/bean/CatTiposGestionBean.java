package seguimiento.bean;

import general.bean.BaseBean;

public class CatTiposGestionBean extends BaseBean{
	
	private String tipoGestionID;
	private String supervisorID;
	private String descripcion;
	private String tipoAsigna;
	private String estatus;
	private String gestorID;
	
	
	public String getTipoGestionID() {
		return tipoGestionID;
	}
	public void setTipoGestionID(String tipoGestionID) {
		this.tipoGestionID = tipoGestionID;
	}
	public String getSupervisorID() {
		return supervisorID;
	}
	public void setSupervisorID(String supervisorID) {
		this.supervisorID = supervisorID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoAsigna() {
		return tipoAsigna;
	}
	public void setTipoAsigna(String tipoAsigna) {
		this.tipoAsigna = tipoAsigna;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getGestorID() {
		return gestorID;
	}
	public void setGestorID(String gestorID) {
		this.gestorID = gestorID;
	}	
}
