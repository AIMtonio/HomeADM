package arrendamiento.bean;

import general.bean.BaseBean;

public class AseguradoraActivoBean  extends BaseBean{
	
	private String aseguradoraID;
	private String descripcion;
	private String estatus;
	private String tipoSeguro;
	
	public String getAseguradoraID() {
		return aseguradoraID;
	}
	public void setAseguradoraID(String aseguradoraID) {
		this.aseguradoraID = aseguradoraID;
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
	public String getTipoSeguro() {
		return tipoSeguro;
	}
	public void setTipoSeguro(String tipoSeguro) {
		this.tipoSeguro = tipoSeguro;
	}	
}
