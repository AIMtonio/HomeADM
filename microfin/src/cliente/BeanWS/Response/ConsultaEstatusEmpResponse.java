package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ConsultaEstatusEmpResponse extends BaseBeanWS {
 private String nombreEmpleado;
 private String estatusActual;
 private String fechaInicialInca;
 private String fechaFinInca;
 private String fechaBaja;
 private String motivoBaja;
 private String codigoRespuesta;
 private String mensajeRespuesta;
 
public String getNombreEmpleado() {
	return nombreEmpleado;
}
public String getEstatusActual() {
	return estatusActual;
}
public String getFechaInicialInca() {
	return fechaInicialInca;
}
public String getFechaFinInca() {
	return fechaFinInca;
}
public String getFechaBaja() {
	return fechaBaja;
}
public String getMotivoBaja() {
	return motivoBaja;
}
public void setNombreEmpleado(String nombreEmpleado) {
	this.nombreEmpleado = nombreEmpleado;
}
public void setEstatusActual(String estatusActual) {
	this.estatusActual = estatusActual;
}
public void setFechaInicialInca(String fechaInicialInca) {
	this.fechaInicialInca = fechaInicialInca;
}
public void setFechaFinInca(String fechaFinInca) {
	this.fechaFinInca = fechaFinInca;
}
public void setFechaBaja(String fechaBaja) {
	this.fechaBaja = fechaBaja;
}
public void setMotivoBaja(String motivoBaja) {
	this.motivoBaja = motivoBaja;
}
public String getCodigoRespuesta() {
	return codigoRespuesta;
}
public String getMensajeRespuesta() {
	return mensajeRespuesta;
}
public void setCodigoRespuesta(String codigoRespuesta) {
	this.codigoRespuesta = codigoRespuesta;
}
public void setMensajeRespuesta(String mensajeRespuesta) {
	this.mensajeRespuesta = mensajeRespuesta;
}
 
}
