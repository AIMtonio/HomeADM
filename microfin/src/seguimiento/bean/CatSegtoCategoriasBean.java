package seguimiento.bean;

import general.bean.BaseBean;

public class CatSegtoCategoriasBean extends BaseBean{
	private String categoriaID;
	private String tipoGestionID;
	private String descripcion;
	private String nombreCorto;
	private String tipoCobranza;
	private String estatus;
	
	
	public String getCategoriaID() {
		return categoriaID;
	}
	public void setCategoriaID(String categoriaID) {
		this.categoriaID = categoriaID;
	}
	public String getTipoGestionID() {
		return tipoGestionID;
	}
	public void setTipoGestionID(String tipoGestionID) {
		this.tipoGestionID = tipoGestionID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNombreCorto() {
		return nombreCorto;
	}
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
	public String getTipoCobranza() {
		return tipoCobranza;
	}
	public void setTipoCobranza(String tipoCobranza) {
		this.tipoCobranza = tipoCobranza;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
}