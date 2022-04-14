package ventanilla.bean;

import general.bean.BaseBean;

public class RepPagServBean extends BaseBean{
private String sucursal;
private String servicio;
private String fechaCargaInicial;
private String fechaCargaFinal;
private String nomInstitucion;
private String claUsuario;

// variables de respuesta de la lista
private String sucursalID;
private String nombreSucurs;
private String catalogoServID;
private String nombreServicio;
private String fecha;
private String referencia;
private String cajaID;
private String montoServicio;
private String ivaServicio;
private String comision;
private String ivaComision;
private String aplicado;
private String origenPago;
private String nombreOrigenPago;


public String getSucursal() {
	return sucursal;
}
public void setSucursal(String sucursal) {
	this.sucursal = sucursal;
}
public String getServicio() {
	return servicio;
}
public void setServicio(String servicio) {
	this.servicio = servicio;
}
public String getFechaCargaInicial() {
	return fechaCargaInicial;
}
public void setFechaCargaInicial(String fechaCargaInicial) {
	this.fechaCargaInicial = fechaCargaInicial;
}
public String getFechaCargaFinal() {
	return fechaCargaFinal;
}
public void setFechaCargaFinal(String fechaCargaFinal) {
	this.fechaCargaFinal = fechaCargaFinal;
}
public String getNomInstitucion() {
	return nomInstitucion;
}
public void setNomInstitucion(String nomInstitucion) {
	this.nomInstitucion = nomInstitucion;
}
public String getClaUsuario() {
	return claUsuario;
}
public void setClaUsuario(String claUsuario) {
	this.claUsuario = claUsuario;
}
public String getOrigenPago() {
	return origenPago;
}
public void setOrigenPago(String origenPago) {
	this.origenPago = origenPago;
}
public String getNombreOrigenPago() {
	return nombreOrigenPago;
}
public void setNombreOrigenPago(String nombreOrigenPago) {
	this.nombreOrigenPago = nombreOrigenPago;
}
public String getSucursalID() {
	return sucursalID;
}
public void setSucursalID(String sucursalID) {
	this.sucursalID = sucursalID;
}
public String getNombreSucurs() {
	return nombreSucurs;
}
public void setNombreSucurs(String nombreSucurs) {
	this.nombreSucurs = nombreSucurs;
}
public String getCatalogoServID() {
	return catalogoServID;
}
public void setCatalogoServID(String catalogoServID) {
	this.catalogoServID = catalogoServID;
}
public String getNombreServicio() {
	return nombreServicio;
}
public void setNombreServicio(String nombreServicio) {
	this.nombreServicio = nombreServicio;
}
public String getFecha() {
	return fecha;
}
public void setFecha(String fecha) {
	this.fecha = fecha;
}
public String getReferencia() {
	return referencia;
}
public void setReferencia(String referencia) {
	this.referencia = referencia;
}
public String getCajaID() {
	return cajaID;
}
public void setCajaID(String cajaID) {
	this.cajaID = cajaID;
}
public String getMontoServicio() {
	return montoServicio;
}
public void setMontoServicio(String montoServicio) {
	this.montoServicio = montoServicio;
}
public String getIvaServicio() {
	return ivaServicio;
}
public void setIvaServicio(String ivaServicio) {
	this.ivaServicio = ivaServicio;
}
public String getComision() {
	return comision;
}
public void setComision(String comision) {
	this.comision = comision;
}
public String getIvaComision() {
	return ivaComision;
}
public void setIvaComision(String ivaComision) {
	this.ivaComision = ivaComision;
}
public String getAplicado() {
	return aplicado;
}
public void setAplicado(String aplicado) {
	this.aplicado = aplicado;
}


	
}