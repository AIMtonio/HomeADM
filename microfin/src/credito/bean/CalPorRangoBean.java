package credito.bean;

import general.bean.BaseBean;

public class CalPorRangoBean extends BaseBean{

	private String limInferior;
	private String limSuperior;
	private String tipoInstitucion;
	private String calificacion;
	private String tipo;
	private String estatus;
	private String clasificacion;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	public String getLimInferior() {
		return limInferior;
	}
	public String getLimSuperior() {
		return limSuperior;
	}
	public String getTipoInstitucion() {
		return tipoInstitucion;
	}
	public String getCalificacion() {
		return calificacion;
	}
	public String getTipo() {
		return tipo;
	}
	public String getEstatus() {
		return estatus;
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
	public void setLimInferior(String limInferior) {
		this.limInferior = limInferior;
	}
	public void setLimSuperior(String limSuperior) {
		this.limSuperior = limSuperior;
	}
	public void setTipoInstitucion(String tipoInstitucion) {
		this.tipoInstitucion = tipoInstitucion;
	}
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
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
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}	
}
