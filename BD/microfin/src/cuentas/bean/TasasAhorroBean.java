package cuentas.bean;

import general.bean.BaseBean;

public class TasasAhorroBean extends BaseBean {
	//Declaracion de Constantes
	public static int LONGITUD_ID = 3;
	
	private String tasaAhorroID;
	private String tipoCuentaID;
	private String tipoPersona;
	private String monedaID;
	private String montoInferior;
	private String montoSuperior;
	private String tasa;
	
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getTasaAhorroID() {
		return tasaAhorroID;
	}
	public void setTasaAhorroID(String tasaAhorroID) {
		this.tasaAhorroID = tasaAhorroID;
	}
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
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
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
}
