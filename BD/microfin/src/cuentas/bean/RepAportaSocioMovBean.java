package cuentas.bean;

import general.bean.BaseBean;

public class RepAportaSocioMovBean extends BaseBean{
	private String clienteID;
	private String saldo;
	private String sucursalID;
	private String fecha;
	private String usuarioID;
	
	private String natMovimiento;
	private String descripcionMov;
	private String cantidadMov;
    
	private String nombreInstit;
	private String direcInstit;
	private String RFCInstit;
	private String telInstit;
	private String nombreCliente;
	
	private String fechaEmision;
	private String direccionSucursal;
	private String representanteLegal;
	
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getSaldo() {
		return saldo;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}

	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getCantidadMov() {
		return cantidadMov;
	}
	public void setCantidadMov(String cantidadMov) {
		this.cantidadMov = cantidadMov;
	}
	public String getNombreInstit() {
		return nombreInstit;
	}
	public String getDirecInstit() {
		return direcInstit;
	}
	public String getRFCInstit() {
		return RFCInstit;
	}
	public String getTelInstit() {
		return telInstit;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	public void setDirecInstit(String direcInstit) {
		this.direcInstit = direcInstit;
	}
	public void setRFCInstit(String rFCInstit) {
		RFCInstit = rFCInstit;
	}
	public void setTelInstit(String telInstit) {
		this.telInstit = telInstit;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getDireccionSucursal() {
		return direccionSucursal;
	}
	public void setDireccionSucursal(String direccionSucursal) {
		this.direccionSucursal = direccionSucursal;
	}
	public String getRepresentanteLegal() {
		return representanteLegal;
	}
	public void setRepresentanteLegal(String representanteLegal) {
		this.representanteLegal = representanteLegal;
	}
}


