package soporte.bean;

import general.bean.BaseBean;

public class TiposPuestosBean extends BaseBean{

	private String tipoPuestoID;
	private String descripcion;
	
	public String getTipoPuestoID() {
		return tipoPuestoID;
	}
	public void setTipoPuestoID(String tipoPuestoID) {
		this.tipoPuestoID = tipoPuestoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
}
