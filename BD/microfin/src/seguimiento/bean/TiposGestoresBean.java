package seguimiento.bean;

import general.bean.BaseBean;

public class TiposGestoresBean extends BaseBean{
	
	private String tipoGestorID;
	private String descripcion;
	
	public String getTipoGestorID() {
		return tipoGestorID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setTipoGestorID(String tipoGestorID) {
		this.tipoGestorID = tipoGestorID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}