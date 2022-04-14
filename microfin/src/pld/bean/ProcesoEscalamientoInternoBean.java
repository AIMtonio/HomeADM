package pld.bean;

import general.bean.BaseBean;

public class ProcesoEscalamientoInternoBean extends BaseBean{

	// Constantes
	
	// Variables o Atributos
	private String procesoEscalamientoID;
	private String descripcion;
	private String estatus;
	
	public String getProcesoEscalamientoID() {
		return procesoEscalamientoID;
	}
	public void setProcesoEscalamientoID(String procesoEscalamientoID) {
		this.procesoEscalamientoID = procesoEscalamientoID;
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
