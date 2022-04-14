package aportaciones.bean;

import general.bean.BaseBean;

public class MontosAportacionesBean extends BaseBean {
	
	private int tipoAportacionID; 
	private String montoInferior;
	private String montoSuperior;
	private String plazoInferior;
	private String plazoSuperior;
	private String montosDescripcion;
	public int getTipoAportacionID() {
		return tipoAportacionID;
	}
	public void setTipoAportacionID(int tipoAportacionID) {
		this.tipoAportacionID = tipoAportacionID;
	}
	public String getMontoInferior() {
		return montoInferior;
	}
	public void setMontoInferior(String montoInferior) {
		this.montoInferior = montoInferior;
	}
	public String getMontoSuperior() {
		return montoSuperior;
	}
	public void setMontoSuperior(String montoSuperior) {
		this.montoSuperior = montoSuperior;
	}
	public String getPlazoInferior() {
		return plazoInferior;
	}
	public void setPlazoInferior(String plazoInferior) {
		this.plazoInferior = plazoInferior;
	}
	public String getPlazoSuperior() {
		return plazoSuperior;
	}
	public void setPlazoSuperior(String plazoSuperior) {
		this.plazoSuperior = plazoSuperior;
	}
	public String getMontosDescripcion() {
		return montosDescripcion;
	}
	public void setMontosDescripcion(String montosDescripcion) {
		this.montosDescripcion = montosDescripcion;
	}
	
	

}
