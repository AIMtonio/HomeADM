package aportaciones.bean;

import general.bean.BaseBean;

public class AportacionesVigentesBean extends BaseBean{
	
	private String aportacionID;
	private String clienteID;
	private String cuentaAhoID;
	private String tipoAportacionID;
	private String fechaInicio;
	private String fechaVencimiento;
	private String pisoTasa;
	private String techoTasa;
	private String monto;
	private String monedaID;
	private String plazo;
	private String plazoOriginal;
	private String tasa;
	
	public String getAportacionID() {
		return aportacionID;
	}
	public void setAportacionID(String aportacionID) {
		this.aportacionID = aportacionID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getTipoAportacionID() {
		return tipoAportacionID;
	}
	public void setTipoAportacionID(String tipoAportacionID) {
		this.tipoAportacionID = tipoAportacionID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getPisoTasa() {
		return pisoTasa;
	}
	public void setPisoTasa(String pisoTasa) {
		this.pisoTasa = pisoTasa;
	}
	public String getTechoTasa() {
		return techoTasa;
	}
	public void setTechoTasa(String techoTasa) {
		this.techoTasa = techoTasa;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getPlazoOriginal() {
		return plazoOriginal;
	}
	public void setPlazoOriginal(String plazoOriginal) {
		this.plazoOriginal = plazoOriginal;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	
	

}
