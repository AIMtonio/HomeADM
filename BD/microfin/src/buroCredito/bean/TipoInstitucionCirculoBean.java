package buroCredito.bean;

import general.bean.BaseBean;

public class TipoInstitucionCirculoBean extends BaseBean {

	private String claveID;
	private String tipoInstitucion;
	private String estatus;
	
	public String getClaveID() {
		return claveID;
	}
	public void setClaveID(String claveID) {
		this.claveID = claveID;
	}
	public String getTipoInstitucion() {
		return tipoInstitucion;
	}
	public void setTipoInstitucion(String tipoInstitucion) {
		this.tipoInstitucion = tipoInstitucion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
	
}
