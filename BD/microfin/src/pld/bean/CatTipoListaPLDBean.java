package pld.bean;

import general.bean.BaseBean;

public class CatTipoListaPLDBean extends BaseBean{
	private String tipoListaID;
	private String descripcion;
	private String estatus;
	public String getTipoListaID() {
		return tipoListaID;
	}
	public void setTipoListaID(String tipoListaID) {
		this.tipoListaID = tipoListaID;
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
