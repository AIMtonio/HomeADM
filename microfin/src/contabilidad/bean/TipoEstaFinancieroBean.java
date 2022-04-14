package contabilidad.bean;

import general.bean.BaseBean;

public class TipoEstaFinancieroBean extends BaseBean{
		
	private String estadoFinanID;
	private String descripcion ;
	public String getEstadoFinanID() {
		return estadoFinanID;
	}
	public void setEstadoFinanID(String estadoFinanID) {
		this.estadoFinanID = estadoFinanID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	
}
