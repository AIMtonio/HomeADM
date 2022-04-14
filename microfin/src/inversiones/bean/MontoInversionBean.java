package inversiones.bean;

import general.bean.BaseBean;


public class MontoInversionBean extends BaseBean {

	private String montoInversionID;
	private String tipoInversionID;
	
	private String plazoInferior;
	private String plazoSuperior;
	
	public String getMontoInversionID() {
		return montoInversionID;
	}
	public void setMontoInversionID(String montoInversionID) {
		this.montoInversionID = montoInversionID;
	}
	public String getTipoInversionID() {
		return tipoInversionID;
	}
	public void setTipoInversionID(String tipoInversionID) {
		this.tipoInversionID = tipoInversionID;
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
	
	
	
	
}
