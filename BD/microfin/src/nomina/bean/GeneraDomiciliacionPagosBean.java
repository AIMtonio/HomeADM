
package nomina.bean;

import general.bean.BaseBean;

public class GeneraDomiciliacionPagosBean extends BaseBean{
	public static int LONGITUD_ID = 10;
	
	private String esNomina;
	private String institNominaID;
	private String convenioNominaID;
	private String clienteID;
	private String frecuencia;
	private String folioID;
	
	private String nombreCliente;
	private String nombreInstitucion;
	private String cuentaClabe;
	private String creditoID;
	private String montoExigible;
	
	private String busqueda;
	private String numTransaccion;
	private String numDomiciliacionID;
	private String institucionID;
	private String nomUsuario;
	
	private String fechaSistema;
	private String consecutivoID;
	private String descripcion;
	private String domiciliacionPagos;
	
	private String rutaArchivo;
	private String nombreArchivo;
	private String folioBanco;
	private String clabeInstitBancaria;
	private String fechaArchivo;
	
	private String consecutivo;
	private String importeTotal;
	private String numEmpleado;
	private String referencia;

	
	// ============ GETTER  & SETTER ============== //

	public String getEsNomina() {
		return esNomina;
	}
	public void setEsNomina(String esNomina) {
		this.esNomina = esNomina;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public String getMontoExigible() {
		return montoExigible;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setMontoExigible(String montoExigible) {
		this.montoExigible = montoExigible;
	}
	public String getBusqueda() {
		return busqueda;
	}
	public void setBusqueda(String busqueda) {
		this.busqueda = busqueda;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getNumDomiciliacionID() {
		return numDomiciliacionID;
	}
	public void setNumDomiciliacionID(String numDomiciliacionID) {
		this.numDomiciliacionID = numDomiciliacionID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNomUsuario() {
		return nomUsuario;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDomiciliacionPagos() {
		return domiciliacionPagos;
	}
	public void setDomiciliacionPagos(String domiciliacionPagos) {
		this.domiciliacionPagos = domiciliacionPagos;
	}
	public String getRutaArchivo() {
		return rutaArchivo;
	}
	public void setRutaArchivo(String rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getFolioBanco() {
		return folioBanco;
	}
	public void setFolioBanco(String folioBanco) {
		this.folioBanco = folioBanco;
	}
	public String getClabeInstitBancaria() {
		return clabeInstitBancaria;
	}
	public void setClabeInstitBancaria(String clabeInstitBancaria) {
		this.clabeInstitBancaria = clabeInstitBancaria;
	}
	public String getFechaArchivo() {
		return fechaArchivo;
	}
	public void setFechaArchivo(String fechaArchivo) {
		this.fechaArchivo = fechaArchivo;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getImporteTotal() {
		return importeTotal;
	}
	public void setImporteTotal(String importeTotal) {
		this.importeTotal = importeTotal;
	}
	public String getNumEmpleado() {
		return numEmpleado;
	}
	public void setNumEmpleado(String numEmpleado) {
		this.numEmpleado = numEmpleado;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	
}