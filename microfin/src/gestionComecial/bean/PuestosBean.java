package gestionComecial.bean;

import general.bean.BaseBean;

public class PuestosBean extends BaseBean{
	
	private String clavePuestoID;
	private String descripcion;
	private String atiendeSuc;
	private String area;
	private String categoriaID;
	private String estatus;
//--------Beans Auxiliares-----------//
	private String esGestor;
	private String esSupervisor;
	
	private String descripcionArea;
	private String descripcionCategoria;
	
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	
	public String getClavePuestoID() {
		return clavePuestoID;
	}
	public void setClavePuestoID(String clavePuestoID) {
		this.clavePuestoID = clavePuestoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getAtiendeSuc() {
		return atiendeSuc;
	}
	public void setAtiendeSuc(String atiendeSuc) {
		this.atiendeSuc = atiendeSuc;
	}	
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getDescripcionArea() {
		return descripcionArea;
	}
	public String getCategoriaID() {
		return categoriaID;
	}
	public void setCategoriaID(String categoriaID) {
		this.categoriaID = categoriaID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getDescripcionCategoria() {
		return descripcionCategoria;
	}
	public void setDescripcionCategoria(String descripcionCategoria) {
		this.descripcionCategoria = descripcionCategoria;
	}
	public void setDescripcionArea(String descripcionArea) {
		this.descripcionArea = descripcionArea;
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
	public String getEsGestor() {
		return esGestor;
	}
	public String getEsSupervisor() {
		return esSupervisor;
	}
	public void setEsSupervisor(String esSupervisor) {
		this.esSupervisor = esSupervisor;
	}
	public void setEsGestor(String esGestor) {
		this.esGestor = esGestor;
	}
	
}
