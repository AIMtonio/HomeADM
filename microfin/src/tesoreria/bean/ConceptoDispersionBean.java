package tesoreria.bean;

import general.bean.BaseBean;

public class ConceptoDispersionBean extends BaseBean{
	private String conceptoID;
	private String nombre;
	private String estatus;
	private String descripcion;
	
	public String getConceptoID() {
		return conceptoID;
	}
	public void setConceptoID(String conceptoID) {
		this.conceptoID = conceptoID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	
}
