package tesoreria.bean;

import general.bean.BaseBean;

public class SubCtaCajeroDivBean extends BaseBean{
	
	private String conceptoMonID; 
	private String cajaID; 
	private String subCuenta;
	
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP; 
	private String programaID; 
	private String sucursal; 
	private String numTransaccion;
	public String getConceptoMonID() {
		return conceptoMonID;
	}
	public String getCajaID() {
		return cajaID;
	}
	public String getSubCuenta() {
		return subCuenta;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setConceptoMonID(String conceptoMonID) {
		this.conceptoMonID = conceptoMonID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public void setSubCuenta(String subCuenta) {
		this.subCuenta = subCuenta;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	

}
