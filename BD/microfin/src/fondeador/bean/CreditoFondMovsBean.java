package fondeador.bean;

import general.bean.BaseBean;

public class CreditoFondMovsBean extends BaseBean {	
	//Atributos
	private String creditoFondeoID;
	private String amortizacionID;
	private String transaccion;
	private String fechaOperacion;
	private String fechaAplicacion;
	private String tipoMovFonID;
	private String natMovimiento;
	private String monedaID;
	private String cantidad;
	private String descripcion;
	private String referencia;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	/*AUXILIARES DEL BEAN */
	private String descripTipMov;
	private String natMovimientoDes; 
	
	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}
	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}
	public String getTransaccion() {
		return transaccion;
	}
	public void setTransaccion(String transaccion) {
		this.transaccion = transaccion;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getFechaAplicacion() {
		return fechaAplicacion;
	}
	public void setFechaAplicacion(String fechaAplicacion) {
		this.fechaAplicacion = fechaAplicacion;
	}
	public String getTipoMovFonID() {
		return tipoMovFonID;
	}
	public void setTipoMovFonID(String tipoMovFonID) {
		this.tipoMovFonID = tipoMovFonID;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
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
	public String getDescripTipMov() {
		return descripTipMov;
	}
	public void setDescripTipMov(String descripTipMov) {
		this.descripTipMov = descripTipMov;
	}
	public String getNatMovimientoDes() {
		return natMovimientoDes;
	}
	public void setNatMovimientoDes(String natMovimientoDes) {
		this.natMovimientoDes = natMovimientoDes;
	}	
}