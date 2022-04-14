package cobranza.bean;

import general.bean.BaseBean;

public class RepAsignaCarteraBean extends BaseBean {
	private String gestorID;
	private String nombreGestor;
	private String tipoAsignacion;
	private String fechaAsignacion;
	private String clienteID;

    private String nombreCompleto;
	private String sucursalCliente;	
	private String creditoID;
	private String nombreProducto;		
	private String telefonoFijo;

	private String telefonoCelular;		
	private String domicilio;		
	private String nombreAval;
	private String domicilioAval;
	private String telefonoAval;
	
	public String getGestorID() {
		return gestorID;
	}
	public void setGestorID(String gestorID) {
		this.gestorID = gestorID;
	}
	public String getNombreGestor() {
		return nombreGestor;
	}
	public void setNombreGestor(String nombreGestor) {
		this.nombreGestor = nombreGestor;
	}
	public String getTipoAsignacion() {
		return tipoAsignacion;
	}
	public void setTipoAsignacion(String tipoAsignacion) {
		this.tipoAsignacion = tipoAsignacion;
	}
	public String getFechaAsignacion() {
		return fechaAsignacion;
	}
	public void setFechaAsignacion(String fechaAsignacion) {
		this.fechaAsignacion = fechaAsignacion;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getSucursalCliente() {
		return sucursalCliente;
	}
	public void setSucursalCliente(String sucursalCliente) {
		this.sucursalCliente = sucursalCliente;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getTelefonoFijo() {
		return telefonoFijo;
	}
	public void setTelefonoFijo(String telefonoFijo) {
		this.telefonoFijo = telefonoFijo;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public String getDomicilio() {
		return domicilio;
	}
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}
	public String getNombreAval() {
		return nombreAval;
	}
	public void setNombreAval(String nombreAval) {
		this.nombreAval = nombreAval;
	}
	public String getDomicilioAval() {
		return domicilioAval;
	}
	public void setDomicilioAval(String domicilioAval) {
		this.domicilioAval = domicilioAval;
	}
	public String getTelefonoAval() {
		return telefonoAval;
	}
	public void setTelefonoAval(String telefonoAval) {
		this.telefonoAval = telefonoAval;
	}	
}