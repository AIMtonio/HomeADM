package pld.bean;

import general.bean.BaseBean;

public class CatDestinoRecursosBean extends BaseBean {
	private String	catDestinoRecID;
	private String	descripcion;
	private String	nivelRiesgo;
	public String getCatDestinoRecID() {
		return catDestinoRecID;
	}
	public void setCatDestinoRecID(String catDestinoRecID) {
		this.catDestinoRecID = catDestinoRecID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
}
