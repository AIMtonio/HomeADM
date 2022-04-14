package gestionComecial.bean;

import general.bean.BaseBean;

public class OrganigramaDetalleBean extends BaseBean{
	
	private String puestoHijoID;
	private String descripcionPuesto;
	private String nombreEmpleado;
	
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;

	private String requiereCtaConta;
	private String ctaContable;
	private String centroCostoID; 
	private String descripcionCtaCon; 
	private String descripcionCenCos; 
	
	public String getPuestoHijoID() {
		return puestoHijoID;
	}
	public void setPuestoHijoID(String puestoHijoID) {
		this.puestoHijoID = puestoHijoID;
	}
	public String getDescripcionPuesto() {
		return descripcionPuesto;
	}
	public void setDescripcionPuesto(String descripcionPuesto) {
		this.descripcionPuesto = descripcionPuesto;
	}
	public String getNombreEmpleado() {
		return nombreEmpleado;
	}
	public void setNombreEmpleado(String nombreEmpleado) {
		this.nombreEmpleado = nombreEmpleado;
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
	public String getRequiereCtaConta() {
		return requiereCtaConta;
	}
	public void setRequiereCtaConta(String requiereCtaConta) {
		this.requiereCtaConta = requiereCtaConta;
	}
	public String getCtaContable() {
		return ctaContable;
	}
	public void setCtaContable(String ctaContable) {
		this.ctaContable = ctaContable;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getDescripcionCtaCon() {
		return descripcionCtaCon;
	}
	public void setDescripcionCtaCon(String descripcionCtaCon) {
		this.descripcionCtaCon = descripcionCtaCon;
	}
	public String getDescripcionCenCos() {
		return descripcionCenCos;
	}
	public void setDescripcionCenCos(String descripcionCenCos) {
		this.descripcionCenCos = descripcionCenCos;
	}	
}
