package originacion.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class ConsolidacionCartaLiqBean extends BaseBean{
	
	private String consolidacionCartaID;
	private String clienteID;
	private String solicitudCreditoID;
	private String estatus;
	private String nombreCompleto;
	private String cartaLiquidaId;
	
	//paramtrso para cartas externas
	private String estatusSolicitud;
	private String nombreCliente;
	private String asignacionCartaID;
	private String casaComercialID;
	private String nombreCasa;
	private String monto;
	private String montoAnterior;
	private String fechaVigencia;
	private String detalleCartas;
	private String tipoCredito;
	private String relacionado;

	// Archivos
	private MultipartFile file;
	private String nombreCartaLiq;
	private String nombreComproPago;
	private String recurso;
	private String recursoPago;
	private String comentario;
	private String extension;
	private String comentarioPago;
	private String extensionPago;
	private String tipoDocumentoID;
	private String nombreReg;
	private String registroAdjunto;
	private String regID;
	private String tipoArchivo;
	private String archivoIDCarta;
	private String archivoIDPago;
	private String modificaArchCarta;
	private String modificaArchPago;
	private String rutaFinalPago;
	private String rutaFinal;
	
	public void setConsolidacionCartaID (String consolidacionCartaID){
		this.consolidacionCartaID = consolidacionCartaID;
	}
	
	public String getConsolidacionCartaID (){
		return consolidacionCartaID;
	}
	
	public void setSolicitudCreditoID (String solicitudCreditoID){
		this.solicitudCreditoID = solicitudCreditoID;
	}
	
	public String getSolicitudCreditoID (){
		return solicitudCreditoID;
	}

	public void setEstatus (String estatus){
		this.estatus = estatus;
	}
	
	public String getEstatus (){
		return estatus;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getEstatusSolicitud() {
		return estatusSolicitud;
	}

	public void setEstatusSolicitud(String estatusSolicitud) {
		this.estatusSolicitud = estatusSolicitud;
	}

	public String getNombreCliente() {
		return nombreCliente;
	}

	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}

	public String getAsignacionCartaID() {
		return asignacionCartaID;
	}

	public void setAsignacionCartaID(String asignacionCartaID) {
		this.asignacionCartaID = asignacionCartaID;
	}

	public String getCasaComercialID() {
		return casaComercialID;
	}

	public void setCasaComercialID(String casaComercialID) {
		this.casaComercialID = casaComercialID;
	}

	public String getNombreCasa() {
		return nombreCasa;
	}

	public void setNombreCasa(String nombreCasa) {
		this.nombreCasa = nombreCasa;
	}

	public String getMonto() {
		return monto;
	}

	public void setMonto(String monto) {
		this.monto = monto;
	}

	public String getMontoAnterior() {
		return montoAnterior;
	}

	public void setMontoAnterior(String montoAnterior) {
		this.montoAnterior = montoAnterior;
	}

	public String getFechaVigencia() {
		return fechaVigencia;
	}

	public void setFechaVigencia(String fechaVigencia) {
		this.fechaVigencia = fechaVigencia;
	}

	public String getDetalleCartas() {
		return detalleCartas;
	}

	public void setDetalleCartas(String detalleCartas) {
		this.detalleCartas = detalleCartas;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getNombreCartaLiq() {
		return nombreCartaLiq;
	}

	public void setNombreCartaLiq(String nombreCartaLiq) {
		this.nombreCartaLiq = nombreCartaLiq;
	}

	public String getNombreComproPago() {
		return nombreComproPago;
	}

	public void setNombreComproPago(String nombreComproPago) {
		this.nombreComproPago = nombreComproPago;
	}

	public String getRecurso() {
		return recurso;
	}

	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}

	public String getRecursoPago() {
		return recursoPago;
	}

	public void setRecursoPago(String recursoPago) {
		this.recursoPago = recursoPago;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	public String getExtension() {
		return extension;
	}

	public void setExtension(String extension) {
		this.extension = extension;
	}

	public String getComentarioPago() {
		return comentarioPago;
	}

	public void setComentarioPago(String comentarioPago) {
		this.comentarioPago = comentarioPago;
	}

	public String getExtensionPago() {
		return extensionPago;
	}

	public void setExtensionPago(String extensionPago) {
		this.extensionPago = extensionPago;
	}

	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}

	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}

	public String getNombreReg() {
		return nombreReg;
	}

	public void setNombreReg(String nombreReg) {
		this.nombreReg = nombreReg;
	}

	public String getRegistroAdjunto() {
		return registroAdjunto;
	}

	public void setRegistroAdjunto(String registroAdjunto) {
		this.registroAdjunto = registroAdjunto;
	}

	public String getRegID() {
		return regID;
	}

	public void setRegID(String regID) {
		this.regID = regID;
	}

	public String getTipoArchivo() {
		return tipoArchivo;
	}

	public void setTipoArchivo(String tipoArchivo) {
		this.tipoArchivo = tipoArchivo;
	}

	public String getArchivoIDCarta() {
		return archivoIDCarta;
	}

	public void setArchivoIDCarta(String archivoIDCarta) {
		this.archivoIDCarta = archivoIDCarta;
	}

	public String getArchivoIDPago() {
		return archivoIDPago;
	}

	public void setArchivoIDPago(String archivoIDPago) {
		this.archivoIDPago = archivoIDPago;
	}

	public String getModificaArchCarta() {
		return modificaArchCarta;
	}

	public void setModificaArchCarta(String modificaArchCarta) {
		this.modificaArchCarta = modificaArchCarta;
	}

	public String getModificaArchPago() {
		return modificaArchPago;
	}

	public void setModificaArchPago(String modificaArchPago) {
		this.modificaArchPago = modificaArchPago;
	}

	public String getRutaFinalPago() {
		return rutaFinalPago;
	}

	public void setRutaFinalPago(String rutaFinalPago) {
		this.rutaFinalPago = rutaFinalPago;
	}

	public String getRutaFinal() {
		return rutaFinal;
	}

	public void setRutaFinal(String rutaFinal) {
		this.rutaFinal = rutaFinal;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getTipoCredito() {
		return tipoCredito;
	}

	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}

	public String getRelacionado() {
		return relacionado;
	}

	public void setRelacionado(String relacionado) {
		this.relacionado = relacionado;
	}

	public String getCartaLiquidaId() {
		return cartaLiquidaId;
	}

	public void setCartaLiquidaId(String cartaLiquidaId) {
		this.cartaLiquidaId = cartaLiquidaId;
	}
	
}
