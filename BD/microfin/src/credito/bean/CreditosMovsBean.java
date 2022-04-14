package credito.bean;

import general.bean.BaseBean;

public class CreditosMovsBean extends BaseBean{
	
	private String creditoID;
	private String fechaOperacion;
	private String descripcion;
	private String tipoMovCreID;
	private String natMovimiento;
	private String cantidad;
	private String amortiCreID;
	
	
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoMovCreID() {
		return tipoMovCreID;
	}
	public void setTipoMovCreID(String tipoMovCreID) {
		this.tipoMovCreID = tipoMovCreID;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getAmortiCreID() {
		return amortiCreID;
	}
	public void setAmortiCreID(String amortiCreID) {
		this.amortiCreID = amortiCreID;
	}
	
	
	
}
