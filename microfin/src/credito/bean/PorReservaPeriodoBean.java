package credito.bean;

import general.bean.BaseBean;

public class PorReservaPeriodoBean extends BaseBean {

	private String limInferior;
	private String limSuperior;
	private String tipoInstitucion;
	private String porResCarSReest;
	private String porResCarReest;
	private String tipoRango;
	private String estatus;
	private String clasificacion;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	private String tipoInst;

	public static String Expuesta="E";
	
	public String getLimInferior() {
		return limInferior;
	}
	public String getLimSuperior() {
		return limSuperior;
	}
	public void setLimInferior(String limInferior) {
		this.limInferior = limInferior;
	}
	public void setLimSuperior(String limSuperior) {
		this.limSuperior = limSuperior;
	}
	public String getTipoInstitucion() {
		return tipoInstitucion;
	}
	public String getPorResCarSReest() {
		return porResCarSReest;
	}
	public String getPorResCarReest() {
		return porResCarReest;
	}
	public String getTipoRango() {
		return tipoRango;
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
	public void setTipoInstitucion(String tipoInstitucion) {
		this.tipoInstitucion = tipoInstitucion;
	}
	public void setPorResCarSReest(String porResCarSReest) {
		this.porResCarSReest = porResCarSReest;
	}
	public void setPorResCarReest(String porResCarReest) {
		this.porResCarReest = porResCarReest;
	}
	public void setTipoRango(String tipoRango) {
		this.tipoRango = tipoRango;
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

	public String getTipoInst() {
		return tipoInst;
	}
	public void setTipoInst(String tipoInst) {
		this.tipoInst = tipoInst;
	}

}
