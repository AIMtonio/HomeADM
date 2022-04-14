package nomina.bean;

import general.bean.BaseBean;

public class NomEsquemaTasaCredBean extends BaseBean {
	private String esqTasaCredID;
	private String sucursalID;
	private String tipoEmpleadoID;
	private String plazoID;
	private String minCred;
	private String maxCred;
	private String montoMin;
	private String montoMax;
	private String tasa;
	private String cantidad;
	private String productoCreditoID;
	private String CondicionCredID;
	
	public String getEsqTasaCredID() {
		return esqTasaCredID;
	}
	public void setEsqTasaCredID(String esqTasaCredID) {
		this.esqTasaCredID = esqTasaCredID;
	}
	
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getTipoEmpleadoID() {
		return tipoEmpleadoID;
	}
	public void setTipoEmpleadoID(String tipoEmpleadoID) {
		this.tipoEmpleadoID = tipoEmpleadoID;
	}
	
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}


	public String getMontoMin() {
		return montoMin;
	}
	public void setMontoMin(String montoMin) {
		this.montoMin = montoMin;
	}
	public String getMontoMax() {
		return montoMax;
	}
	public void setMontoMax(String montoMax) {
		this.montoMax = montoMax;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getMinCred() {
		return minCred;
	}
	public void setMinCred(String minCred) {
		this.minCred = minCred;
	}
	public String getMaxCred() {
		return maxCred;
	}
	public void setMaxCred(String maxCred) {
		this.maxCred = maxCred;
	}
	public String getCondicionCredID() {
		return CondicionCredID;
	}
	public void setCondicionCredID(String condicionCredID) {
		CondicionCredID = condicionCredID;
	}
	

}
