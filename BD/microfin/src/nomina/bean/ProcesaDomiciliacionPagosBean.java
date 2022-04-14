package nomina.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

public class ProcesaDomiciliacionPagosBean extends BaseBean{
	
	// Definicion de Atributos
	
	private String folioID;
	private String clienteID;
	private String institucionID;
	private String cuentaClabe;
	private String creditoID;

	private String monto;
	private String montoPendiente;
	private String montoAplicado;
	private String estatus;
	private String comentario;
	
	private String claveDomiciliacion;
	private String nombreInstitucion;
	private String nombreCliente;

	private CommonsMultipartFile file = null;
	
	/*Parametros auxiliares para subir archivos*/
	private String descripcion;
	private String nombreControl;
	private String consecutivoString;
	private String consecutivoInt;
	private int numero;
	
	private String NumError;
	private String DescError;
	private int LineaError;
	public int exitosos=0;
	public int fallidos=0;
	
	public String polizaID;
	public String fechaSistema;
	private String numEmpleado;
	private String referencia;
	private String montoExigible;

	private String consecutivoID;
	private String rutaArchivo;
	private String nombreArchivo;
	private String clabeInstitBancaria;
	private String consecutivo;
	
	private String importeTotal;
	private String fechaArchivo;
	private String numFolioID;

	// ============ GETTER  & SETTER ============== //

	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getMontoPendiente() {
		return montoPendiente;
	}
	public void setMontoPendiente(String montoPendiente) {
		this.montoPendiente = montoPendiente;
	}
	public String getMontoAplicado() {
		return montoAplicado;
	}
	public void setMontoAplicado(String montoAplicado) {
		this.montoAplicado = montoAplicado;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public CommonsMultipartFile getFile() {
		return file;
	}
	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNombreControl() {
		return nombreControl;
	}
	public void setNombreControl(String nombreControl) {
		this.nombreControl = nombreControl;
	}
	public String getConsecutivoString() {
		return consecutivoString;
	}
	public void setConsecutivoString(String consecutivoString) {
		this.consecutivoString = consecutivoString;
	}
	public String getConsecutivoInt() {
		return consecutivoInt;
	}
	public void setConsecutivoInt(String consecutivoInt) {
		this.consecutivoInt = consecutivoInt;
	}
	public int getNumero() {
		return numero;
	}
	public void setNumero(int numero) {
		this.numero = numero;
	}
	public String getNumError() {
		return NumError;
	}
	public void setNumError(String numError) {
		NumError = numError;
	}
	public String getDescError() {
		return DescError;
	}
	public void setDescError(String descError) {
		DescError = descError;
	}
	public int getLineaError() {
		return LineaError;
	}
	public void setLineaError(int lineaError) {
		LineaError = lineaError;
	}
	public int getExitosos() {
		return exitosos;
	}
	public void setExitosos(int exitosos) {
		this.exitosos = exitosos;
	}
	public int getFallidos() {
		return fallidos;
	}
	public void setFallidos(int fallidos) {
		this.fallidos = fallidos;
	}
	public String getClaveDomiciliacion() {
		return claveDomiciliacion;
	}
	public void setClaveDomiciliacion(String claveDomiciliacion) {
		this.claveDomiciliacion = claveDomiciliacion;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNumEmpleado() {
		return numEmpleado;
	}
	public String getReferencia() {
		return referencia;
	}
	public String getMontoExigible() {
		return montoExigible;
	}
	public void setNumEmpleado(String numEmpleado) {
		this.numEmpleado = numEmpleado;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public void setMontoExigible(String montoExigible) {
		this.montoExigible = montoExigible;
	}
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public String getRutaArchivo() {
		return rutaArchivo;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public String getClabeInstitBancaria() {
		return clabeInstitBancaria;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public String getImporteTotal() {
		return importeTotal;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public void setRutaArchivo(String rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public void setClabeInstitBancaria(String clabeInstitBancaria) {
		this.clabeInstitBancaria = clabeInstitBancaria;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public void setImporteTotal(String importeTotal) {
		this.importeTotal = importeTotal;
	}
	public String getFechaArchivo() {
		return fechaArchivo;
	}
	public void setFechaArchivo(String fechaArchivo) {
		this.fechaArchivo = fechaArchivo;
	}
	public String getNumFolioID() {
		return numFolioID;
	}
	public void setNumFolioID(String numFolioID) {
		this.numFolioID = numFolioID;
	}
}