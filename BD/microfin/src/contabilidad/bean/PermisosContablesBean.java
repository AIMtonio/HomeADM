package contabilidad.bean;

import general.bean.BaseBean;

public class PermisosContablesBean extends BaseBean{
	private String usuarioID;
	private String afectacionFeVa;
	private String cierreEjercicio;
	private String cierrePeriodo;
	private String modificaPolizas;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getUsuarioID() { 
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getAfectacionFeVa() {
		return afectacionFeVa;
	}
	public void setAfectacionFeVa(String afectacionFeVa) {
		this.afectacionFeVa = afectacionFeVa;
	}
	public String getCierreEjercicio() {
		return cierreEjercicio;
	}
	public void setCierreEjercicio(String cierreEjercicio) {
		this.cierreEjercicio = cierreEjercicio;
	}
	public String getCierrePeriodo() {
		return cierrePeriodo;
	}
	public void setCierrePeriodo(String cierrePeriodo) {
		this.cierrePeriodo = cierrePeriodo;
	}
	public String getModificaPolizas() {
		return modificaPolizas;
	}
	public void setModificaPolizas(String modificaPolizas) {
		this.modificaPolizas = modificaPolizas;
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
