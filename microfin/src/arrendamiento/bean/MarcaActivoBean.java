package arrendamiento.bean;

import general.bean.BaseBean;

public class MarcaActivoBean  extends BaseBean{
	
	private String marcaID;
	private String tipoActivo;
	private String descripcion;
	private String estatus;
	
	public String getMarcaID() {
		return marcaID;
	}
	public void setMarcaID(String marcaID) {
		this.marcaID = marcaID;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}
	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
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
