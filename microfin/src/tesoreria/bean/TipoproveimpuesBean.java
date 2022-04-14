package tesoreria.bean;

import general.bean.BaseBean;
import java.util.List;

public class TipoproveimpuesBean extends BaseBean{
	
	
	private String tipoProveedorID;
	private String impuestoID;
	private String orden;
	private String tasa;
	private String descripcion;
	private String descripCorta;
	private String gravaRetiene;
	private String baseCalculo;
	private String impuestoCalculo;
	
	
	private List ltipoProveedorID;
	private List limpuestoID;
	private List lorden;
	private List ltasa;
	private List ldescripcion;
	private List ldescripCorta;
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	
	public String getTipoProveedorID() {
		return tipoProveedorID;
	}
	public void setTipoProveedorID(String tipoProveedorID) {
		this.tipoProveedorID = tipoProveedorID;
	}
	public String getImpuestoID() {
		return impuestoID;
	}
	public void setImpuestoID(String impuestoID) {
		this.impuestoID = impuestoID;
	}
	public String getOrden() {
		return orden;
	}
	public void setOrden(String orden) {
		this.orden = orden;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public String getDescripCorta() {
		return descripCorta;
	}
	public void setDescripCorta(String descripCorta) {
		this.descripCorta = descripCorta;
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
	
	public List getLtipoProveedorID() {
		return ltipoProveedorID;
	}
	public void setLtipoProveedorID(List ltipoProveedorID) {
		this.ltipoProveedorID = ltipoProveedorID;
	}
	public List getLimpuestoID() {
		return limpuestoID;
	}
	public void setLimpuestoID(List limpuestoID) {
		this.limpuestoID = limpuestoID;
	}
	public List getLorden() {
		return lorden;
	}
	public void setLorden(List lorden) {
		this.lorden = lorden;
	}
	public List getLtasa() {
		return ltasa;
	}
	public void setLtasa(List ltasa) {
		this.ltasa = ltasa;
	}
	public List getLdescripcion() {
		return ldescripcion;
	}
	public void setLdescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public List getLdescripCorta() {
		return ldescripCorta;
	}
	public void setLdescripCorta(List ldescripCorta) {
		this.ldescripCorta = ldescripCorta;
	}

	
	
}
