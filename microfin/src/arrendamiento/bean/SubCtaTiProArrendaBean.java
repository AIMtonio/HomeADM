package arrendamiento.bean;

import general.bean.BaseBean;

public class SubCtaTiProArrendaBean extends BaseBean{
	private String conceptoArrendaID;
	private String productoArrendaID;
	private String subCuenta;
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;

	public String getConceptoArrendaID() {
		return conceptoArrendaID;
	}
	public void setConceptoArrendaID(String conceptoArrendaID) {
		this.conceptoArrendaID = conceptoArrendaID;
	}
	public String getProductoArrendaID() {
		return productoArrendaID;
	}
	public void setProductoArrendaID(String productoArrendaID) {
		this.productoArrendaID = productoArrendaID;
	}
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
	
	
}
