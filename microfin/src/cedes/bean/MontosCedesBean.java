package cedes.bean;

import general.bean.BaseBean;

public class MontosCedesBean extends BaseBean{

	private int tipoCedeID; 
	private String montoInferior;
	private String montoSuperior;
	private String plazoInferior;
	private String plazoSuperior;
	private String montosDescripcion;
	
	
	public String getMontosDescripcion() {
		return montosDescripcion;
	}
	public void setMontosDescripcion(String montosDescripcion) {
		this.montosDescripcion = montosDescripcion;
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
	public int getTipoCedeID() {
		return tipoCedeID;
	}
	public void setTipoCedeID(int tipoCedeID) {
		this.tipoCedeID = tipoCedeID;
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

}
