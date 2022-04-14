package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;

public class MotivoCancelacionChequesBean extends BaseBean{
	
	private String motivoID;
	private String descripcion;
	private String estatus;
	
	private List lmotivoID;
	private List ldescripcion;
	private List lestatus;
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	private String numCancela;
	
	public String getMotivoID() {
		return motivoID;
	}
	public void setMotivoID(String motivoID) {
		this.motivoID = motivoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public List getLmotivoID() {
		return lmotivoID;
	}
	public void setLmotivoID(List lmotivoID) {
		this.lmotivoID = lmotivoID;
	}
	public List getLdescripcion() {
		return ldescripcion;
	}
	public void setLdescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public List getLestatus() {
		return lestatus;
	}
	public void setLestatus(List lestatus) {
		this.lestatus = lestatus;
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
	public String getNumCancela() {
		return numCancela;
	}
	public void setNumCancela(String numCancela) {
		this.numCancela = numCancela;
	}	
}
