package aportaciones.bean;

import general.bean.BaseBean;

public class PlazosAportacionesBean extends BaseBean {
	
	private int tipoAportacionID; 
	private int plazoInferior;
	private int plazoSuperior;
	private String plazosDescripcion;
	
	public int getTipoAportacionID() {
		return tipoAportacionID;
	}
	public void setTipoAportacionID(int tipoAportacionID) {
		this.tipoAportacionID = tipoAportacionID;
	}
	public int getPlazoInferior() {
		return plazoInferior;
	}
	public void setPlazoInferior(int plazoInferior) {
		this.plazoInferior = plazoInferior;
	}
	public int getPlazoSuperior() {
		return plazoSuperior;
	}
	public void setPlazoSuperior(int plazoSuperior) {
		this.plazoSuperior = plazoSuperior;
	}
	public String getPlazosDescripcion() {
		return plazosDescripcion;
	}
	public void setPlazosDescripcion(String plazosDescripcion) {
		this.plazosDescripcion = plazosDescripcion;
	}

}
