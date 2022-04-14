package tesoreria.bean;

import general.bean.BaseBean;

public class CondicionespagoBean extends BaseBean{

	private String condicionPagoID;
	private String descripcion; 
	private String numeroDias;
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	
	public String getCondicionPagoID() {
		return condicionPagoID;
	}
	public void setCondicionPagoID(String condicionPagoID) {
		this.condicionPagoID = condicionPagoID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	
	public String getNumeroDias() {
		return numeroDias;
	}
	public void setNumeroDias(String numeroDias) {
		this.numeroDias = numeroDias;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
