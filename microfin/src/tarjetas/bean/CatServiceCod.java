package tarjetas.bean;

import general.bean.BaseBean;

public class CatServiceCod extends BaseBean{
	
	private String catServiceCodeID;
	private String numeroServicio;
	private String descripcion;
	
	public String getCatServiceCodeID() {
		return catServiceCodeID;
	}
	public void setCatServiceCodeID(String catServiceCodeID) {
		this.catServiceCodeID = catServiceCodeID;
	}
	public String getNumeroServicio() {
		return numeroServicio;
	}
	public void setNumeroServicio(String numeroServicio) {
		this.numeroServicio = numeroServicio;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
}
