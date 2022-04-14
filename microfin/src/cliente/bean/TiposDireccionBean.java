package cliente.bean;

import general.bean.BaseBean;

public class TiposDireccionBean extends BaseBean{

	private String tipoDireccionID;
	private String empresaID;
	private String descripcion;
	private String oficial;
	private String  usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	public String getTipoDireccionID() {
		return tipoDireccionID;
	}
	public void setTipoDireccionID(String tipoDireccionID) {
		this.tipoDireccionID = tipoDireccionID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getOficial() {
		return oficial;
	}
	public void setOficial(String oficial) {
		this.oficial = oficial;
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
