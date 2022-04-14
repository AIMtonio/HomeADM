package soporte.bean;

import general.bean.BaseBean;

public class CuentasCorreoBean extends BaseBean {
	
	private int cuentaCorreoID;
	private String correoContactoCliente; 
	private String asuntoContactoCliente;

	private String correoPromocion; 
	private String asuntoPromocion;

	private String correoRiesgos; 
	private String asuntoRiesgos;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
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
	public int getCuentaCorreoID() {
		return cuentaCorreoID;
	}
	public void setCuentaCorreoID(int cuentaCorreoID) {
		this.cuentaCorreoID = cuentaCorreoID;
	}
	public String getCorreoContactoCliente() {
		return correoContactoCliente;
	}
	public void setCorreoContactoCliente(String correoContactoCliente) {
		this.correoContactoCliente = correoContactoCliente;
	}
	public String getAsuntoContactoCliente() {
		return asuntoContactoCliente;
	}
	public void setAsuntoContactoCliente(String asuntoContactoCliente) {
		this.asuntoContactoCliente = asuntoContactoCliente;
	}
	public String getCorreoPromocion() {
		return correoPromocion;
	}
	public void setCorreoPromocion(String correoPromocion) {
		this.correoPromocion = correoPromocion;
	}
	public String getAsuntoPromocion() {
		return asuntoPromocion;
	}
	public void setAsuntoPromocion(String asuntoPromocion) {
		this.asuntoPromocion = asuntoPromocion;
	}
	public String getCorreoRiesgos() {
		return correoRiesgos;
	}
	public void setCorreoRiesgos(String correoRiesgos) {
		this.correoRiesgos = correoRiesgos;
	}
	public String getAsuntoRiesgos() {
		return asuntoRiesgos;
	}
	public void setAsuntoRiesgos(String asuntoRiesgos) {
		this.asuntoRiesgos = asuntoRiesgos;
	}

	
	
}
