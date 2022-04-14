package spei.bean;

import general.bean.BaseBean;

public class CuentaClabePMoralBean extends BaseBean {
	private String speiCuentaPMoralID;
	private String clienteID;
	private String cuentaClabe;
	private String fechaCreacion;
	private String estatus;
	private String tipoInstrumento;
	private String instrumento;
	private String descEstatus;
	
	public String getSpeiCuentaPMoralID() {
		return speiCuentaPMoralID;
	}
	public void setSpeiCuentaPMoralID(String speiCuentaPMoralID) {
		this.speiCuentaPMoralID = speiCuentaPMoralID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getFechaCreacion() {
		return fechaCreacion;
	}
	public void setFechaCreacion(String fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTipoInstrumento() {
		return tipoInstrumento;
	}
	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}
	public String getInstrumento() {
		return instrumento;
	}
	public void setInstrumento(String instrumento) {
		this.instrumento = instrumento;
	}
	public String getDescEstatus() {
		return descEstatus;
	}
	public void setDescEstatus(String descEstatus) {
		this.descEstatus = descEstatus;
	}
	
	
}
