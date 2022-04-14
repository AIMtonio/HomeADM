package arrendamiento.bean;

import general.bean.BaseBean;

public class SegurosVidaArrendaBean extends BaseBean{
	private String seguroVidaArrendaID;
	private String descripcion;
	public String getSeguroVidaArrendaID() {
		return seguroVidaArrendaID;
	}
	public void setSeguroVidaArrendaID(String seguroVidaArrendaID) {
		this.seguroVidaArrendaID = seguroVidaArrendaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
