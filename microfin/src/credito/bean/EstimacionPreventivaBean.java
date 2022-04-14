package credito.bean;

import general.bean.BaseBean;

public class EstimacionPreventivaBean extends BaseBean {

	private String fechaCorte;
	private String aplicacionContable;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	// beans para reserva por credito

	private String totalReserva;
	private String saldoCap;
	private String saldoInt;
	private String creditoID;
	private String polizaID;
	
	public static String conceptoEstimacionPreventiva = "56";
	public static String conceptoEstimacionPreventivaDes = "GENERACION DE RESERVAS";
	

	public String getFechaCorte() {
		return fechaCorte;
	}
	public void setFechaCorte(String fechaCorte) {
		this.fechaCorte = fechaCorte;
	}
	public String getAplicacionContable() {
		return aplicacionContable;
	}
	public void setAplicacionContable(String aplicacionContable) {
		this.aplicacionContable = aplicacionContable;
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
	
	private String ultimaFecha;
	public String getUltimaFecha() {
		return ultimaFecha;
	}
	public void setUltimaFecha(String ultimaFecha) {
		this.ultimaFecha = ultimaFecha;
	}
	public String getTotalReserva() {
		return totalReserva;
	}
	public void setTotalReserva(String totalReserva) {
		this.totalReserva = totalReserva;
	}
	public String getSaldoCap() {
		return saldoCap;
	}
	public void setSaldoCap(String saldoCap) {
		this.saldoCap = saldoCap;
	}
	public String getSaldoInt() {
		return saldoInt;
	}
	public void setSaldoInt(String saldoInt) {
		this.saldoInt = saldoInt;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	
	
}
