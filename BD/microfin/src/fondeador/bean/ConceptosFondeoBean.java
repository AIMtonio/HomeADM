package fondeador.bean;

import general.bean.BaseBean;

public class ConceptosFondeoBean extends BaseBean{
	private String conceptoFondID;
	private String empresaID;
	private String descripcion;
	
	
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
	public String getConceptoFondID() {
		return conceptoFondID;
	}
	public void setConceptoFondID(String conceptoFondID) {
		this.conceptoFondID = conceptoFondID;
	}
}
