package nomina.bean;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import general.bean.BaseBean;

public class ArchivoInstalBean extends BaseBean{

	private String folioID;
	private String folioIDAnterior;
	private String descripcion;
	private String institNominaID;
	private String nombreInstNomina;
	private String convenioNominaID;
	private String nombreConvNomina;
	private String usuario;
	private String fechaSistema;
	private String nombreInstitucion;
	private String estatus;
	
	// Reporte Propiedades
	private String solicitudCreditoID;
	private String creditoID;
	private String nombreInstit;
	private String nombreCompleto;
	private String RFC;
	private String CURP;
	private String montoCredito;
	private String montoPagare;
	private String tasaAnual;
	private String tasaMensual;
	private String plazo;
	private String numAmortizacion;
	private String fechaInicioAmor;
	private String fechaVencimiento;
	private String interesTotal;
	private String IVAInteresTotal;
	private String montoAccesoriosTotal;
	private String montoIVAAccesoriosTotal;
	private String montoInteresTotal;
	private String montoIVAInteresTotal;
	private String interes;
	private String IVAInteres;
	private String montoAccesorios;
	private String montoIVAAccesorios;
	private String montoInteres;
	private String montoIVAInteres;
	private String numeroEmpleado;
	private String estatusNomina;
	private String descuentoPeriodico;
	
	// Propiedades Excel
	private String numError;
	private String descError;
	private int lineaError;
	private CommonsMultipartFile file = null;
	
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getFolioIDAnterior() {
		return folioIDAnterior;
	}
	public void setFolioIDAnterior(String folioIDAnterior) {
		this.folioIDAnterior = folioIDAnterior;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getNombreInstNomina() {
		return nombreInstNomina;
	}
	public void setNombreInstNomina(String nombreInstNomina) {
		this.nombreInstNomina = nombreInstNomina;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getNombreConvNomina() {
		return nombreConvNomina;
	}
	public void setNombreConvNomina(String nombreConvNomina) {
		this.nombreConvNomina = nombreConvNomina;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNombreInstit() {
		return nombreInstit;
	}
	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getCURP() {
		return CURP;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getMontoPagare() {
		return montoPagare;
	}
	public void setMontoPagare(String montoPagare) {
		this.montoPagare = montoPagare;
	}
	public String getTasaAnual() {
		return tasaAnual;
	}
	public void setTasaAnual(String tasaAnual) {
		this.tasaAnual = tasaAnual;
	}
	public String getTasaMensual() {
		return tasaMensual;
	}
	public void setTasaMensual(String tasaMensual) {
		this.tasaMensual = tasaMensual;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getNumAmortizacion() {
		return numAmortizacion;
	}
	public void setNumAmortizacion(String numAmortizacion) {
		this.numAmortizacion = numAmortizacion;
	}
	public String getFechaInicioAmor() {
		return fechaInicioAmor;
	}
	public void setFechaInicioAmor(String fechaInicioAmor) {
		this.fechaInicioAmor = fechaInicioAmor;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getInteresTotal() {
		return interesTotal;
	}
	public void setInteresTotal(String interesTotal) {
		this.interesTotal = interesTotal;
	}
	public String getIVAInteresTotal() {
		return IVAInteresTotal;
	}
	public void setIVAInteresTotal(String iVAInteresTotal) {
		IVAInteresTotal = iVAInteresTotal;
	}
	public String getMontoAccesoriosTotal() {
		return montoAccesoriosTotal;
	}
	public void setMontoAccesoriosTotal(String montoAccesoriosTotal) {
		this.montoAccesoriosTotal = montoAccesoriosTotal;
	}
	public String getMontoIVAAccesoriosTotal() {
		return montoIVAAccesoriosTotal;
	}
	public void setMontoIVAAccesoriosTotal(String montoIVAAccesoriosTotal) {
		this.montoIVAAccesoriosTotal = montoIVAAccesoriosTotal;
	}
	public String getMontoInteresTotal() {
		return montoInteresTotal;
	}
	public void setMontoInteresTotal(String montoInteresTotal) {
		this.montoInteresTotal = montoInteresTotal;
	}
	public String getMontoIVAInteresTotal() {
		return montoIVAInteresTotal;
	}
	public void setMontoIVAInteresTotal(String montoIVAInteresTotal) {
		this.montoIVAInteresTotal = montoIVAInteresTotal;
	}
	public String getInteres() {
		return interes;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public String getIVAInteres() {
		return IVAInteres;
	}
	public void setIVAInteres(String iVAInteres) {
		IVAInteres = iVAInteres;
	}
	public String getMontoAccesorios() {
		return montoAccesorios;
	}
	public void setMontoAccesorios(String montoAccesorios) {
		this.montoAccesorios = montoAccesorios;
	}
	public String getMontoIVAAccesorios() {
		return montoIVAAccesorios;
	}
	public void setMontoIVAAccesorios(String montoIVAAccesorios) {
		this.montoIVAAccesorios = montoIVAAccesorios;
	}
	public String getMontoInteres() {
		return montoInteres;
	}
	public void setMontoInteres(String montoInteres) {
		this.montoInteres = montoInteres;
	}
	public String getMontoIVAInteres() {
		return montoIVAInteres;
	}
	public void setMontoIVAInteres(String montoIVAInteres) {
		this.montoIVAInteres = montoIVAInteres;
	}
	public String getNumeroEmpleado() {
		return numeroEmpleado;
	}
	public void setNumeroEmpleado(String numeroEmpleado) {
		this.numeroEmpleado = numeroEmpleado;
	}
	public String getEstatusNomina() {
		return estatusNomina;
	}
	public void setEstatusNomina(String estatusNomina) {
		this.estatusNomina = estatusNomina;
	}
	public String getDescuentoPeriodico() {
		return descuentoPeriodico;
	}
	public void setDescuentoPeriodico(String descuentoPeriodico) {
		this.descuentoPeriodico = descuentoPeriodico;
	}
	public String getNumError() {
		return numError;
	}
	public void setNumError(String numError) {
		this.numError = numError;
	}
	public String getDescError() {
		return descError;
	}
	public void setDescError(String descError) {
		this.descError = descError;
	}
	public int getLineaError() {
		return lineaError;
	}
	public void setLineaError(int lineaError) {
		this.lineaError = lineaError;
	}
	public CommonsMultipartFile getFile() {
		return file;
	}
	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
}
