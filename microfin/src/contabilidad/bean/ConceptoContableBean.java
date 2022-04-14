package contabilidad.bean;

import general.bean.BaseBean;


public class ConceptoContableBean extends BaseBean {

	//Definicion de Constantes
	
	//Definicion de Variables
	
	private String conceptoContableID;
	private String descripcion;
	private String empresaID;
	
	public String getConceptoContableID() {
		return conceptoContableID;
	}
	public void setConceptoContableID(String conceptoContableID) {
		this.conceptoContableID = conceptoContableID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	
	
	
}
