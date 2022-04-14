package cuentas.bean;

import general.bean.BaseBean;

public class ConceptosAhorroBean extends BaseBean{
	private String conceptoAhoID;
	private String empresaID;
	private String descripcion;
	
	public String getConceptoAhoID() {
		return conceptoAhoID;
	}
	public void setConceptoAhoID(String conceptoAhoID) {
		this.conceptoAhoID = conceptoAhoID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
