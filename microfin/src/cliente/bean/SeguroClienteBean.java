package cliente.bean;

import general.bean.BaseBean;

public class SeguroClienteBean extends BaseBean{
	private String seguroClienteID;
	private String clienteID;
	private String fechaInicio;
	private String fechaVencimiento;
	private String estatus;           	
	private String montoSegPagado;
	private String nombreCliente;
	
	private String montoPolizaSegAyuda;
	private String montoSeguroApoyo;
	//auxiliar para cancelacion de seguros
	private String sucursalSeguro;
	private String motivoCambioEstatus;
	private String observacion;
	private String claveUsuarioAutoriza;
	private String contrasenia;
	
	public String getSeguroClienteID() {
		return seguroClienteID;
	}
	public void setSeguroClienteID(String seguroClienteID) {
		this.seguroClienteID = seguroClienteID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
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
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
	public String getMontoSegPagado() {
		return montoSegPagado;
	}
	public void setMontoSegPagado(String montoSegPagado) {
		this.montoSegPagado = montoSegPagado;
	}
	
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getMontoPolizaSegAyuda() {
		return montoPolizaSegAyuda;
	}
	public void setMontoPolizaSegAyuda(String montoPolizaSegAyuda) {
		this.montoPolizaSegAyuda = montoPolizaSegAyuda;
	}
	public String getMontoSeguroApoyo() {
		return montoSeguroApoyo;
	}
	public void setMontoSeguroApoyo(String montoSeguroApoyo) {
		this.montoSeguroApoyo = montoSeguroApoyo;
	}
	public String getSucursalSeguro() {
		return sucursalSeguro;
	}
	public void setSucursalSeguro(String sucursalSeguro) {
		this.sucursalSeguro = sucursalSeguro;
	}
	public String getMotivoCambioEstatus() {
		return motivoCambioEstatus;
	}
	public void setMotivoCambioEstatus(String motivoCambioEstatus) {
		this.motivoCambioEstatus = motivoCambioEstatus;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getClaveUsuarioAutoriza() {
		return claveUsuarioAutoriza;
	}
	public void setClaveUsuarioAutoriza(String claveUsuarioAutoriza) {
		this.claveUsuarioAutoriza = claveUsuarioAutoriza;
	}
	
	
}
