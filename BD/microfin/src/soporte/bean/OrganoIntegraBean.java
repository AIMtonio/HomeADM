package soporte.bean;
import general.bean.BaseBean;

public class OrganoIntegraBean extends  BaseBean {
	
	private String organoID;
	private String clavePuestoID;
	
	private	String usuario;
	private	String sucursal;
	private	String fechaActual;
	private	String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	// Auxiliares
	private String asignado;
	private String descripcionPuesto;
	
	
	
	public String getOrganoID() {
		return organoID;
	}
	public String getClavePuestoID() {
		return clavePuestoID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getSucursal() {
		return sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setOrganoID(String organoID) {
		this.organoID = organoID;
	}
	public void setClavePuestoID(String clavePuestoID) {
		this.clavePuestoID = clavePuestoID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getAsignado() {
		return asignado;
	}
	public void setAsignado(String asignado) {
		this.asignado = asignado;
	}
	public String getDescripcionPuesto() {
		return descripcionPuesto;
	}
	public void setDescripcionPuesto(String descripcionPuesto) {
		this.descripcionPuesto = descripcionPuesto;
	}
	
	
	

}
