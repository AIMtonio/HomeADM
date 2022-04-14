package cedes.bean;

import general.bean.BaseBean;

public class CuentasMayorCedeBean extends BaseBean{
	private String conceptoCedeID;  
	private String empresaID; 
	private String cuenta; 
	private String nomenclatura; 
	private String nomenclaturaCR; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP; 
	private String programaID; 
	private String sucursal;
	private String numTransaccion;
	
	
	public String getConceptoCedeID() {
		return conceptoCedeID;
	}
	public void setConceptoCedeID(String conceptoCedeID) {
		this.conceptoCedeID = conceptoCedeID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getCuenta() {
		return cuenta;
	}
	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}
	public String getNomenclatura() {
		return nomenclatura;
	}
	public void setNomenclatura(String nomenclatura) {
		this.nomenclatura = nomenclatura;
	}
	public String getNomenclaturaCR() {
		return nomenclaturaCR;
	}
	public void setNomenclaturaCR(String nomenclaturaCR) {
		this.nomenclaturaCR = nomenclaturaCR;
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
