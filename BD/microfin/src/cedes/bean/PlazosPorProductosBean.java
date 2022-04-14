package cedes.bean;

import general.bean.BaseBean;

public class PlazosPorProductosBean extends BaseBean{
	private String plazoID; 
	private String plazo;
	private String tipoInstrumentoID;
	private String tipoProductoID;
	
	
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getTipoInstrumentoID() {
		return tipoInstrumentoID;
	}
	public void setTipoInstrumentoID(String tipoInstrumentoID) {
		this.tipoInstrumentoID = tipoInstrumentoID;
	}
	public String getTipoProductoID() {
		return tipoProductoID;
	}
	public void setTipoProductoID(String tipoProductoID) {
		this.tipoProductoID = tipoProductoID;
	}
}
