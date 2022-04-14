package originacion.bean;

import general.bean.BaseBean;

public class CreditosPlazosBean extends BaseBean{
	
	private String plazoID;
	private String dias;
	private String descripcion;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	//auxiliares enb consulta de fecha de vencimiento de credito en base a el numero de cuotas
	private String frecuenciaCap;
	private String numCuotas;
	private String periodicidadCap;
	private String producCreditoID;
	
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getDias() {
		return dias;
	}
	public void setDias(String dias) {
		this.dias = dias;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
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
	public String getFrecuenciaCap() {
		return frecuenciaCap;
	}
	public void setFrecuenciaCap(String frecuenciaCap) {
		this.frecuenciaCap = frecuenciaCap;
	}
	public String getNumCuotas() {
		return numCuotas;
	}
	public void setNumCuotas(String numCuotas) {
		this.numCuotas = numCuotas;
	}
	public String getPeriodicidadCap() {
		return periodicidadCap;
	}
	public void setPeriodicidadCap(String periodicidadCap) {
		this.periodicidadCap = periodicidadCap;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}

	
}
