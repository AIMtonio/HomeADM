package arrendamiento.bean;

import general.bean.BaseBean;

public class SubtipoActivoBean  extends BaseBean{
	
	private String subtipoActivoID;
	private String descripcion;
	private String estatus;
	
	public String getSubtipoActivoID() {
		return subtipoActivoID;
	}
	public void setSubtipoActivoID(String subtipoActivoID) {
		this.subtipoActivoID = subtipoActivoID;
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
