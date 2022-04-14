package credito.bean;

import general.bean.BaseBean;

public class CirculoCreTipConBean extends BaseBean {
	private String 	tipoContratoCCID;
	private String	descripcion;
	
	private String	empresaID;
	private String	usuario;
	private String	fechaActual;
	private String	direccionIP;
	private String	programaID;
	private String	sucursal;
	private String	numTransaccion;
	
	public String getTipoContratoCCID() {
		return tipoContratoCCID;
	}
	public void setTipoContratoCCID(String tipoContratoCCID) {
		this.tipoContratoCCID = tipoContratoCCID;
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
}
