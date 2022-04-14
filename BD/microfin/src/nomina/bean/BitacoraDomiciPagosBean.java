package nomina.bean;

import general.bean.BaseBean;

public class BitacoraDomiciPagosBean extends BaseBean{
	
	private String consecutivoID;
	private String folioID;
	private String fecha;
	private String clienteID;
	private String nombreCliente;
	private String institucionID;
	private String nombreInstitucion;
	private String cuentaClabe;
	private String creditoID;
	private String montoAplicado;
	private String montoNoAplicado;
	private String claveDomicilia;//Estatus del codigo de respuesta
	private String reprocesado;
	private String institNominaID;
	private String nombreInstitNomina;
	private String referencia;
	private String frecuencia;
	private String descFrecuencia;
	
	private String hora;
	private String convenio;
	private String cuotasPendientes;
	private String FechaVencimiento;
	private String montoOtorgado;
	private String numCuotas;
	private String montoCuota;
	private String numTransaccion;
	private String montoPendiente;
	
	private String fechaInicio;
	private String fechaFin;
	
	private String fechaReporte;
	private String institNomina;
	
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
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
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getMontoAplicado() {
		return montoAplicado;
	}
	public void setMontoAplicado(String montoAplicado) {
		this.montoAplicado = montoAplicado;
	}
	public String getMontoNoAplicado() {
		return montoNoAplicado;
	}
	public void setMontoNoAplicado(String montoNoAplicado) {
		this.montoNoAplicado = montoNoAplicado;
	}
	public String getClaveDomicilia() {
		return claveDomicilia;
	}
	public void setClaveDomicilia(String claveDomicilia) {
		this.claveDomicilia = claveDomicilia;
	}
	public String getReprocesado() {
		return reprocesado;
	}
	public void setReprocesado(String reprocesado) {
		this.reprocesado = reprocesado;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getNombreInstitNomina() {
		return nombreInstitNomina;
	}
	public void setNombreInstitNomina(String nombreInstitNomina) {
		this.nombreInstitNomina = nombreInstitNomina;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getDescFrecuencia() {
		return descFrecuencia;
	}
	public void setDescFrecuencia(String descFrecuencia) {
		this.descFrecuencia = descFrecuencia;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getConvenio() {
		return convenio;
	}
	public void setConvenio(String convenio) {
		this.convenio = convenio;
	}
	public String getCuotasPendientes() {
		return cuotasPendientes;
	}
	public void setCuotasPendientes(String cuotasPendientes) {
		this.cuotasPendientes = cuotasPendientes;
	}
	public String getFechaVencimiento() {
		return FechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		FechaVencimiento = fechaVencimiento;
	}
	public String getMontoOtorgado() {
		return montoOtorgado;
	}
	public void setMontoOtorgado(String montoOtorgado) {
		this.montoOtorgado = montoOtorgado;
	}
	public String getNumCuotas() {
		return numCuotas;
	}
	public void setNumCuotas(String numCuotas) {
		this.numCuotas = numCuotas;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getFechaReporte() {
		return fechaReporte;
	}
	public void setFechaReporte(String fechaReporte) {
		this.fechaReporte = fechaReporte;
	}
	public String getMontoPendiente() {
		return montoPendiente;
	}
	public void setMontoPendiente(String montoPendiente) {
		this.montoPendiente = montoPendiente;
	}
	public String getInstitNomina() {
		return institNomina;
	}
	public void setInstitNomina(String institNomina) {
		this.institNomina = institNomina;
	}
	
	
	
}
