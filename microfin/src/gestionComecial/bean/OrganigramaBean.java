package gestionComecial.bean;

import general.bean.BaseBean;

public class OrganigramaBean extends BaseBean{
	
	private String PuestoPadreID;
	private String PuestoHijoID;
	
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;

	private String jefeInmediato;
	private String requiereCtaConta;
	private String ctaContable;
	private String centroCostoID;  
		
	public String getPuestoPadreID() {
		return PuestoPadreID;
	}
	public void setPuestoPadreID(String puestoPadreID) {
		PuestoPadreID = puestoPadreID;
	}
	public String getPuestoHijoID() {
		return PuestoHijoID;
	}
	public void setPuestoHijoID(String puestoHijoID) {
		PuestoHijoID = puestoHijoID;
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
	public String getJefeInmediato() {
		return jefeInmediato;
	}
	public void setJefeInmediato(String jefeInmediato) {
		this.jefeInmediato = jefeInmediato;
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
}
