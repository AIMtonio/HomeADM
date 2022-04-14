package arrendamiento.bean;

import general.bean.BaseBean;

public class TipoMovsCargoAbonoArrendaBean extends BaseBean{

	// ATRIBUTOS DE LA TABLA 
	private String tipMovCargoAbonoID;
	private String descripcion;
	private String columArrendaAmorti;
	
	
	public String getTipMovCargoAbonoID() {
		return tipMovCargoAbonoID;
	}
	public void setTipMovCargoAbonoID(String tipMovCargoAbonoID) {
		this.tipMovCargoAbonoID = tipMovCargoAbonoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getColumArrendaAmorti() {
		return columArrendaAmorti;
	}
	public void setColumArrendaAmorti(String columArrendaAmorti) {
		this.columArrendaAmorti = columArrendaAmorti;
	}	
}
