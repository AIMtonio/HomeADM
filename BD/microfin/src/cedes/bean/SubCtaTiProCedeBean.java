package cedes.bean;

import general.bean.BaseBean;

public class SubCtaTiProCedeBean extends BaseBean{
	private String conceptoCedeID;
	private String tipoCedeID; 
	private String subCuenta; 
	
	private String empresaID; 
	private String usuario;  
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	public String getConceptoCedeID() {
		return conceptoCedeID;
	}
	public void setConceptoCedeID(String conceptoCedeID) {
		this.conceptoCedeID = conceptoCedeID;
	}
	public String getTipoCedeID() {
		return tipoCedeID;
	}
	public void setTipoCedeID(String tipoCedeID) {
		this.tipoCedeID = tipoCedeID;
	}
	public String getSubCuenta() {
		return subCuenta;
	}
	public void setSubCuenta(String subCuenta) {
		this.subCuenta = subCuenta;
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
	
}
