package activos.bean;

import general.bean.BaseBean;

public class ClasifTiposActivosBean extends BaseBean{
	private String clasificaActivoID;
	private String descripcion;
	private String estatus;
	
	public String getClasificaActivoID() {
		return clasificaActivoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setClasificaActivoID(String clasificaActivoID) {
		this.clasificaActivoID = clasificaActivoID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}	
}
