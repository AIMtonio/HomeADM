package cuentas.bean;

import general.bean.BaseBean;

public class AltaTiposSoporteBean extends BaseBean{
	
	private String tipoSoporteID;
	private String descripcion;

	public String getTipoSoporteID() {
		return tipoSoporteID;
	}
	public void setTipoSoporteID(String tipoSoporteID) {
		this.tipoSoporteID = tipoSoporteID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}

