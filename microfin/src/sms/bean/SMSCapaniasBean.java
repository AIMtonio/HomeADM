package sms.bean;

import general.bean.BaseBean;

public class SMSCapaniasBean extends BaseBean{
	
	private String campaniaID;
	private String nombre;
	private String clasificacion;
	private String categoria;
	private String tipo;
	private String fechaLimiteRes;
	private String estatus;
	
	
	private String msgRecepcion;	
	private String plantillaID;

	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
					
	public String getPlantillaID() {
		return plantillaID;
	}
	public void setPlantillaID(String plantillaID) {
		this.plantillaID = plantillaID;
	}
	public String getMsgRecepcion() {
		return msgRecepcion;
	}
	public void setMsgRecepcion(String msgRecepcion) {
		this.msgRecepcion = msgRecepcion;
	}
	
	
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCampaniaID() {
		return campaniaID;
	}
	public void setCampaniaID(String campaniaID) {
		this.campaniaID = campaniaID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getCategoria() {
		return categoria;
	}
	public void setCategoria(String categoria) {
		this.categoria = categoria;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getFechaLimiteRes() {
		return fechaLimiteRes;
	}
	public void setFechaLimiteRes(String fechaLimiteRes) {
		this.fechaLimiteRes = fechaLimiteRes;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	
	
	
	
}
