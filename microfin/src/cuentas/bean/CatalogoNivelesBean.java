package cuentas.bean;

import general.bean.BaseBean;

public class CatalogoNivelesBean extends BaseBean {

	private String nivelID;
	private String descripcion;

	public String getNivelID() {
		return nivelID;
	}

	public void setNivelID(String nivelID) {
		this.nivelID = nivelID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

}
