package pld.bean;

import general.bean.BaseBean;

public class OperEscalamientoInternoBean extends BaseBean{
	// Constantes
	
	// Variables o Atributos
	private String procesoEscalamientoID;
	private String folioOperacionID;
	private String fechaDeteccion;
	private String sucursalDeteccion;
	private String clienteID;
	private String matchNivelRiesgo;
	
	private String matchPEPs;
	private String matchCuenta3SinDeclarar;
	private String matchDetalleDocumentacion;
	private String matchMontoTransaccion;
	private String matchOtroProceso;
	private String descripcionOtro;
	private String funcionarioUsuarioID;
	private String resultadoRevision;
	private String claveJustificacion;
	private String solicitaSeguimiento;
	private String notasComentarios;
	private String fechaGestion;
	
	//Detalle de la Operacion Que Origino el Escalamiento
	String nombreCliente;
	String rfcCliente;
	String nivelRiesgoCliente;
	String fechaSolicitud;
	String montoOperacion;
	String productoInstrumento;
	
	public String getProcesoEscalamientoID() {
		return procesoEscalamientoID;
	}
	public void setProcesoEscalamientoID(String procesoEscalamientoID) {
		this.procesoEscalamientoID = procesoEscalamientoID;
	}
	public String getFolioOperacionID() {
		return folioOperacionID;
	}
	public void setFolioOperacionID(String folioOperacionID) {
		this.folioOperacionID = folioOperacionID;
	}
	public String getFechaDeteccion() {
		return fechaDeteccion;
	}
	public void setFechaDeteccion(String fechaDeteccion) {
		this.fechaDeteccion = fechaDeteccion;
	}
	public String getSucursalDeteccion() {
		return sucursalDeteccion;
	}
	public void setSucursalDeteccion(String sucursalDeteccion) {
		this.sucursalDeteccion = sucursalDeteccion;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMatchNivelRiesgo() {
		return matchNivelRiesgo;
	}
	public void setMatchNivelRiesgo(String matchNivelRiesgo) {
		this.matchNivelRiesgo = matchNivelRiesgo;
	}
	public String getMatchPEPs() {
		return matchPEPs;
	}
	public void setMatchPEPs(String matchPEPs) {
		this.matchPEPs = matchPEPs;
	}
	public String getMatchCuenta3SinDeclarar() {
		return matchCuenta3SinDeclarar;
	}
	public void setMatchCuenta3SinDeclarar(String matchCuenta3SinDeclarar) {
		this.matchCuenta3SinDeclarar = matchCuenta3SinDeclarar;
	}
	public String getMatchDetalleDocumentacion() {
		return matchDetalleDocumentacion;
	}
	public void setMatchDetalleDocumentacion(String matchDetalleDocumentacion) {
		this.matchDetalleDocumentacion = matchDetalleDocumentacion;
	}
	public String getMatchMontoTransaccion() {
		return matchMontoTransaccion;
	}
	public void setMatchMontoTransaccion(String matchMontoTransaccion) {
		this.matchMontoTransaccion = matchMontoTransaccion;
	}
	public String getMatchOtroProceso() {
		return matchOtroProceso;
	}
	public void setMatchOtroProceso(String matchOtroProceso) {
		this.matchOtroProceso = matchOtroProceso;
	}
	public String getDescripcionOtro() {
		return descripcionOtro;
	}
	public void setDescripcionOtro(String descripcionOtro) {
		this.descripcionOtro = descripcionOtro;
	}
	public String getFuncionarioUsuarioID() {
		return funcionarioUsuarioID;
	}
	public void setFuncionarioUsuarioID(String funcionarioUsuarioID) {
		this.funcionarioUsuarioID = funcionarioUsuarioID;
	}
	public String getResultadoRevision() {
		return resultadoRevision;
	}
	public void setResultadoRevision(String resultadoRevision) {
		this.resultadoRevision = resultadoRevision;
	}
	public String getClaveJustificacion() {
		return claveJustificacion;
	}
	public void setClaveJustificacion(String claveJustificacion) {
		this.claveJustificacion = claveJustificacion;
	}
	public String getSolicitaSeguimiento() {
		return solicitaSeguimiento;
	}
	public void setSolicitaSeguimiento(String solicitaSeguimiento) {
		this.solicitaSeguimiento = solicitaSeguimiento;
	}
	public String getNotasComentarios() {
		return notasComentarios;
	}
	public void setNotasComentarios(String notasComentarios) {
		this.notasComentarios = notasComentarios;
	}
	public String getFechaGestion() {
		return fechaGestion;
	}
	public void setFechaGestion(String fechaGestion) {
		this.fechaGestion = fechaGestion;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getRfcCliente() {
		return rfcCliente;
	}
	public void setRfcCliente(String rfcCliente) {
		this.rfcCliente = rfcCliente;
	}
	public String getNivelRiesgoCliente() {
		return nivelRiesgoCliente;
	}
	public void setNivelRiesgoCliente(String nivelRiesgoCliente) {
		this.nivelRiesgoCliente = nivelRiesgoCliente;
	}
	public String getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(String fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getProductoInstrumento() {
		return productoInstrumento;
	}
	public void setProductoInstrumento(String productoInstrumento) {
		this.productoInstrumento = productoInstrumento;
	}
	
	
	
}
