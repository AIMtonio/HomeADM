package pld.bean;

import general.bean.BaseBean;

public class PeriodosReelevantesBean extends BaseBean{
	
	private String periodoReeID;
	private String descripcion;
	private String mesDiaInicio;
	private String mesDiaFin;

	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	public String getPeriodoReeID() {
		return periodoReeID;
	}
	public void setPeriodoReeID(String periodoReeID) {
		this.periodoReeID = periodoReeID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getMesDiaInicio() {
		return mesDiaInicio;
	}
	public void setMesDiaInicio(String mesDiaInicio) {
		this.mesDiaInicio = mesDiaInicio;
	}
	public String getMesDiaFin() {
		return mesDiaFin;
	}
	public void setMesDiaFin(String mesDiaFin) {
		this.mesDiaFin = mesDiaFin;
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
