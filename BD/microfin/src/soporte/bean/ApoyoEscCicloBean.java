package soporte.bean;

import general.bean.BaseBean;

public class ApoyoEscCicloBean extends BaseBean {

	/*Declaracion de atributos */
	private String apoyoEscCicloID;
	private String descripcion;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;	
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	/* ============ SETTER's Y GETTER's =============== */
	
	public String getApoyoEscCicloID() {
		return apoyoEscCicloID;
	}
	public String getDescripcion() {
		return descripcion;
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
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setApoyoEscCicloID(String apoyoEscCicloID) {
		this.apoyoEscCicloID = apoyoEscCicloID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

	


}