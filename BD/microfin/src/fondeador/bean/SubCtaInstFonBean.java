package fondeador.bean;

import general.bean.BaseBean;

public class SubCtaInstFonBean extends BaseBean{
	private String conceptoFondID;
	private String tipoFondeador;

	private String conceptoFonID;
	private String institutFondID;
	private String subCuenta;
	private String subCuentaIns;

	private String empresaID; 
	private String usuario; 
	private String fechaActual;
	private String direccionIP;
	
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	public String getSubCuenta() {
		return subCuenta;
	}
	public void setSubCuenta(String subCuenta) {
		this.subCuenta = subCuenta;
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
	public String getConceptoFonID() {
		return conceptoFonID;
	}
	public void setConceptoFonID(String conceptoFonID) {
		this.conceptoFonID = conceptoFonID;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public String getConceptoFondID() {
		return conceptoFondID;
	}
	public void setConceptoFondID(String conceptoFondID) {
		this.conceptoFondID = conceptoFondID;
	}
	
	public String getSubCuentaIns() {
		return subCuentaIns;
	}
	public void setSubCuentaIns(String subCuentaIns) {
		this.subCuentaIns = subCuentaIns;
	}
	public String getTipoFondeador() {
		return tipoFondeador;
	}
	public void setTipoFondeador(String tipoFondeador) {
		this.tipoFondeador = tipoFondeador;
	}
}
