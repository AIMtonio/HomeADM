package arrendamiento.bean;

import general.bean.BaseBean;

public class SegurosArrendaBean extends BaseBean{
	private String seguroArrendaID;
	private String descripcion;
	public String getSeguroArrendaID() {
		return seguroArrendaID;
	}
	public void setSeguroArrendaID(String seguroArrendaID) {
		this.seguroArrendaID = seguroArrendaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

}
