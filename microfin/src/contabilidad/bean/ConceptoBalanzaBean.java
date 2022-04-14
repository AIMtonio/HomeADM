package contabilidad.bean;

import general.bean.BaseBean;

public class ConceptoBalanzaBean extends BaseBean{
	private String conBalanzaID;
	private String descripcion;
	
	public String getConBalanzaID() {
		return conBalanzaID;
	}
	public void setConBalanzaID(String conBalanzaID) {
		this.conBalanzaID = conBalanzaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
