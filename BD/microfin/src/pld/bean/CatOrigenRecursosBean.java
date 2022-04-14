package pld.bean;

import general.bean.BaseBean;

public class CatOrigenRecursosBean extends BaseBean {
	private String	catOrigenRecID;
	private String	descripcion;
	private String	nivelRiesgo;
	public String getCatOrigenRecID() {
		return catOrigenRecID;
	}
	public void setCatOrigenRecID(String catOrigenRecID) {
		this.catOrigenRecID = catOrigenRecID;
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
