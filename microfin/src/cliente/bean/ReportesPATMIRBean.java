package cliente.bean;

import general.bean.BaseBean;

public class ReportesPATMIRBean extends BaseBean{
private String fechaReporte;
private String tipoReporte;

// Parametros de reporte SOCIOS PATMIR
private String clienteID;
private String curp;
private String nombre;
private String apellidoPaterno;
private String apellidoMaterno;
private String fechaRegistro;
private String fechaBaja;
private String fechaNacimiento;
private String estadoNacimiento;
private String genero;
private String nombreLocalidad;
private String calle;
private String lengInd;
private String edoCivil;
private String colonia;
private String recibeServVent; 
private String idNivEstudios;
private String idNivIngresos;
private String tipoRep;
private String tipoRepMenores;
private String fechaAlta;
private String montoInv;
private String total;

//Parametros de reporte PARTE SOCIAL PATMIR
//cliente id
private String ClavePatmir;
private String ParteSocial;

//Parametros de reporte CREDITOS PATMIR
private String ClavePA;
private String SocioID;
private String Prestamo;

//Parametros de reporte CUENTAS PATMIR
// String ClavePA
private String Socio;
private String Ahorro;

//Parametros de reporte BAJAS PATMIR
// String Socio
// String fechaBaja;

public String getFechaReporte() {
	return fechaReporte;
}
public void setFechaReporte(String fechaReporte) {
	this.fechaReporte = fechaReporte;
}
public String getTipoReporte() {
	return tipoReporte;
}
public void setTipoReporte(String tipoReporte) {
	this.tipoReporte = tipoReporte;
}
public String getClienteID() {
	return clienteID;
}
public void setClienteID(String clienteID) {
	this.clienteID = clienteID;
}
public String getCurp() {
	return curp;
}
public void setCurp(String curp) {
	this.curp = curp;
}
public String getNombre() {
	return nombre;
}
public void setNombre(String nombre) {
	this.nombre = nombre;
}
public String getApellidoPaterno() {
	return apellidoPaterno;
}
public void setApellidoPaterno(String apellidoPaterno) {
	this.apellidoPaterno = apellidoPaterno;
}
public String getApellidoMaterno() {
	return apellidoMaterno;
}
public void setApellidoMaterno(String apellidoMaterno) {
	this.apellidoMaterno = apellidoMaterno;
}
public String getFechaRegistro() {
	return fechaRegistro;
}
public void setFechaRegistro(String fechaRegistro) {
	this.fechaRegistro = fechaRegistro;
}
public String getFechaBaja() {
	return fechaBaja;
}
public void setFechaBaja(String fechaBaja) {
	this.fechaBaja = fechaBaja;
}
public String getFechaNacimiento() {
	return fechaNacimiento;
}
public void setFechaNacimiento(String fechaNacimiento) {
	this.fechaNacimiento = fechaNacimiento;
}
public String getEstadoNacimiento() {
	return estadoNacimiento;
}
public void setEstadoNacimiento(String estadoNacimiento) {
	this.estadoNacimiento = estadoNacimiento;
}
public String getGenero() {
	return genero;
}
public void setGenero(String genero) {
	this.genero = genero;
}
public String getNombreLocalidad() {
	return nombreLocalidad;
}
public void setNombreLocalidad(String nombreLocalidad) {
	this.nombreLocalidad = nombreLocalidad;
}
public String getCalle() {
	return calle;
}
public void setCalle(String calle) {
	this.calle = calle;
}
public String getLengInd() {
	return lengInd;
}
public void setLengInd(String lengInd) {
	this.lengInd = lengInd;
}
public String getEdoCivil() {
	return edoCivil;
}
public void setEdoCivil(String edoCivil) {
	this.edoCivil = edoCivil;
}
public String getColonia() {
	return colonia;
}
public void setColonia(String colonia) {
	this.colonia = colonia;
}
public String getRecibeServVent() {
	return recibeServVent;
}
public void setRecibeServVent(String recibeServVent) {
	this.recibeServVent = recibeServVent;
}
public String getIdNivEstudios() {
	return idNivEstudios;
}
public void setIdNivEstudios(String idNivEstudios) {
	this.idNivEstudios = idNivEstudios;
}
public String getIdNivIngresos() {
	return idNivIngresos;
}
public void setIdNivIngresos(String idNivIngresos) {
	this.idNivIngresos = idNivIngresos;
}
public String getClavePatmir() {
	return ClavePatmir;
}
public void setClavePatmir(String clavePatmir) {
	ClavePatmir = clavePatmir;
}
public String getParteSocial() {
	return ParteSocial;
}
public void setParteSocial(String parteSocial) {
	ParteSocial = parteSocial;
}
public String getClavePA() {
	return ClavePA;
}
public void setClavePA(String clavePA) {
	ClavePA = clavePA;
}
public String getSocioID() {
	return SocioID;
}
public void setSocioID(String socioID) {
	SocioID = socioID;
}
public String getPrestamo() {
	return Prestamo;
}
public void setPrestamo(String prestamo) {
	Prestamo = prestamo;
}
public String getSocio() {
	return Socio;
}
public void setSocio(String socio) {
	Socio = socio;
}
public String getAhorro() {
	return Ahorro;
}
public void setAhorro(String ahorro) {
	Ahorro = ahorro;
}
public String getTipoRep() {
	return tipoRep;
}
public void setTipoRep(String tipoRep) {
	this.tipoRep = tipoRep;
}
public String getTipoRepMenores() {
	return tipoRepMenores;
}
public void setTipoRepMenores(String tipoRepMenores) {
	this.tipoRepMenores = tipoRepMenores;
}
public String getFechaAlta() {
	return fechaAlta;
}
public void setFechaAlta(String fechaAlta) {
	this.fechaAlta = fechaAlta;
}
public String getMontoInv() {
	return montoInv;
}
public void setMontoInv(String montoInv) {
	this.montoInv = montoInv;
}
public String getTotal() {
	return total;
}
public void setTotal(String total) {
	this.total = total;
}


}
