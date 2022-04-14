package soporte.bean;

import general.bean.BaseBean;

public class OrganoDecisionBean extends  BaseBean {
	
	private String organoID;
	private String descripcion;
	
	private	String usuario;
	private	String sucursal;
	private	String fechaActual;
	private	String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	
	
	public String getOrganoID() {
		return organoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getSucursal() {
		return sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setOrganoID(String organoID) {
		this.organoID = organoID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	

}
