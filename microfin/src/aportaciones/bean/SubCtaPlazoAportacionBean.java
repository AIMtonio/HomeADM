package aportaciones.bean;

import general.bean.BaseBean;

public class SubCtaPlazoAportacionBean extends BaseBean{
	
	private String conceptoAportacionID; 
	private String tipoAportacionID; 
	private String plazoInferior;
	private String plazoSuperior;
	private String subCuenta; 
	private String subCtaPlazoAportacionID;
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP; 
	private String programaID; 
	private String sucursal;
	private String numTransaccion;
	
	public String getConceptoAportacionID() {
		return conceptoAportacionID;
	}
	public void setConceptoAportacionID(String conceptoAportacionID) {
		this.conceptoAportacionID = conceptoAportacionID;
	}
	public String getTipoAportacionID() {
		return tipoAportacionID;
	}
	public void setTipoAportacionID(String tipoAportacionID) {
		this.tipoAportacionID = tipoAportacionID;
	}
	public String getPlazoInferior() {
		return plazoInferior;
	}
	public void setPlazoInferior(String plazoInferior) {
		this.plazoInferior = plazoInferior;
	}
	public String getPlazoSuperior() {
		return plazoSuperior;
	}
	public void setPlazoSuperior(String plazoSuperior) {
		this.plazoSuperior = plazoSuperior;
	}
	public String getSubCuenta() {
		return subCuenta;
	}
	public void setSubCuenta(String subCuenta) {
		this.subCuenta = subCuenta;
	}
	public String getSubCtaPlazoAportacionID() {
		return subCtaPlazoAportacionID;
	}
	public void setSubCtaPlazoAportacionID(String subCtaPlazoAportacionID) {
		this.subCtaPlazoAportacionID = subCtaPlazoAportacionID;
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
