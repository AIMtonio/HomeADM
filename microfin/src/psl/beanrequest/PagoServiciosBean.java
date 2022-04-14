package psl.beanrequest;

import psl.rest.BaseBeanRequest;

public class PagoServiciosBean extends BaseBeanRequest {
	private String telefono;
	private String servicioID;
	private String productoID;
	private String horaLocal;
	private String referencia;
	private String montoPago;
	private String identificador;
	private String usuario;
	private String usuarioIP;
	private String sucursalUsuario;
	
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getServicioID() {
		return servicioID;
	}
	public void setServicioID(String servicioID) {
		this.servicioID = servicioID;
	}
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
	public String getHoraLocal() {
		return horaLocal;
	}
	public void setHoraLocal(String horaLocal) {
		this.horaLocal = horaLocal;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getMontoPago() {
		return montoPago;
	}
	public void setMontoPago(String montoPago) {
		this.montoPago = montoPago;
	}
	public String getIdentificador() {
		return identificador;
	}
	public void setIdentificador(String identificador) {
		this.identificador = identificador;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getUsuarioIP() {
		return usuarioIP;
	}
	public void setUsuarioIP(String usuarioIP) {
		this.usuarioIP = usuarioIP;
	}
	public String getSucursalUsuario() {
		return sucursalUsuario;
	}
	public void setSucursalUsuario(String sucursalUsuario) {
		this.sucursalUsuario = sucursalUsuario;
	}
}
