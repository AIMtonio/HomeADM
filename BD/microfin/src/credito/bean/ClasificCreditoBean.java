package credito.bean;

import general.bean.BaseBean;

public class ClasificCreditoBean  extends BaseBean{
	private String clasificacionID;
	private String tipoClasificacion;
	private String descripClasifica;
	private String codigoClasific; 
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getClasificacionID() {
		return clasificacionID;
	}
	public void setClasificacionID(String clasificacionID) {
		this.clasificacionID = clasificacionID;
	}
	public String getTipoClasificacion() {
		return tipoClasificacion;
	}
	public void setTipoClasificacion(String tipoClasificacion) {
		this.tipoClasificacion = tipoClasificacion;
	}
	public String getDescripClasifica() {
		return descripClasifica;
	}
	public void setDescripClasifica(String descripClasifica) {
		this.descripClasifica = descripClasifica;
	}
	public String getCodigoClasific() {
		return codigoClasific;
	}
	public void setCodigoClasific(String codigoClasific) {
		this.codigoClasific = codigoClasific;
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
