package tarjetas.bean;

import general.bean.BaseBean;

public class ConceptosTarDebBean extends BaseBean{
	private String conceptoTarDebID;
	private String descripcion;
	
	public String getConceptoTarDebID() {
		return conceptoTarDebID;
	}
	public void setConceptoTarDebID(String conceptoTarDebID) {
		this.conceptoTarDebID = conceptoTarDebID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
