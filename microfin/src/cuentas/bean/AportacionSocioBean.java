package cuentas.bean;


import general.bean.BaseBean;

public class AportacionSocioBean extends BaseBean{
private String clienteID;
private String saldo;
private String sucursalID;
private String fechaRegistro;
private String fechaImp;
private String usuarioID;
private String creditoID;
private String cuentaAhoID;
private String inversionID;
private String montoAplicacion;

// para el reporte de Movimientos



public String getUsuarioID() {
	return usuarioID;
}
public void setUsuarioID(String usuarioID) {
	this.usuarioID = usuarioID;
}
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
public String getFechaRegistro() {
	return fechaRegistro;
}
public void setFechaRegistro(String fechaRegistro) {
	this.fechaRegistro = fechaRegistro;
}
public String getCreditoID() {
	return creditoID;
}
public void setCreditoID(String creditoID) {
	this.creditoID = creditoID;
}

public String getCuentaAhoID() {
	return cuentaAhoID;
}
public void setCuentaAhoID(String cuentaAhoID) {
	this.cuentaAhoID = cuentaAhoID;
}
public String getInversionID() {
	return inversionID;
}
public void setInversionID(String inversionID) {
	this.inversionID = inversionID;
}
public String getMontoAplicacion() {
	return montoAplicacion;
}
public void setMontoAplicacion(String montoAplicacion) {
	this.montoAplicacion = montoAplicacion;
}
public String getFechaImp() {
	return fechaImp;
}
public void setFechaImp(String fechaImp) {
	this.fechaImp = fechaImp;
}




}