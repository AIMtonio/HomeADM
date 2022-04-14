package fira.bean;

import general.bean.BaseBean;

public class CatTipoGarantiaFIRABean extends BaseBean {

	private String	tipoGarantiaID;
	private String	descripcion;

	public String getTipoGarantiaID() {
		return tipoGarantiaID;
	}
	public void setTipoGarantiaID(String tipoGarantiaID) {
		this.tipoGarantiaID = tipoGarantiaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

}
