package cedes.bean;

import general.bean.BaseBean;

public class PlazosCedesBean extends BaseBean {

	private int tipoCedeID; 
	private int plazoInferior;
	private int plazoSuperior;
	private String plazosDescripcion;
	
	
	public String getPlazosDescripcion() {
		return plazosDescripcion;
	}
	public void setPlazosDescripcion(String plazosDescripcion) {
		this.plazosDescripcion = plazosDescripcion;
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
	public int getTipoCedeID() {
		return tipoCedeID;
	}
	public void setTipoCedeID(int tipoCedeID) {
		this.tipoCedeID = tipoCedeID;
	}
	
}
