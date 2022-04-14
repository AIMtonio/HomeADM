package operacionesVBC.bean;

import general.bean.BaseBean;

public class VbcSimuladorCreditoBean extends BaseBean {
	
	//Atributos o Variables
	private String amortizacionID;
	private String fechaInicio;
	private String fechaVencim;
	private String fechaExigible;		
	private String capital;

	private String interes;
	private String ivaInteres;
	private String totalPago;
	private String saldoInsoluto;
	private String dias;

	private String cuotasCapital;
	private String numTransacSim;
	private String cat;
	private String fecUltAmor;
	private String fecInicioAmor;

	private String montoCuota;
	private String totalCap;
	private String totalInteres;
	private String totalIva;
	private String cobraSeguroCuota;

	private String montoSeguroCuota;
	private String iVASeguroCuota;
	private String totalSeguroCuota;
	private String totalIVASeguroCuota; 
     
	private String codigoError;
	private String mensajeError;
	private String numTransaccion;
	
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getFecUltAmor() {
		return fecUltAmor;
	}
	public void setFecUltAmor(String fecUltAmor) {
		this.fecUltAmor = fecUltAmor;
	}
	public String getFecInicioAmor() {
		return fecInicioAmor;
	}
	public void setFecInicioAmor(String fecInicioAmor) {
		this.fecInicioAmor = fecInicioAmor;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getTotalCap() {
		return totalCap;
	}
	public void setTotalCap(String totalCap) {
		this.totalCap = totalCap;
	}
	public String getTotalInteres() {
		return totalInteres;
	}
	public void setTotalInteres(String totalInteres) {
		this.totalInteres = totalInteres;
	}
	public String getTotalIva() {
		return totalIva;
	}
	public void setTotalIva(String totalIva) {
		this.totalIva = totalIva;
	}
	
	public String getTotalSeguroCuota() {
		return totalSeguroCuota;
	}
	public void setTotalSeguroCuota(String totalSeguroCuota) {
		this.totalSeguroCuota = totalSeguroCuota;
	}
	public String getTotalIVASeguroCuota() {
		return totalIVASeguroCuota;
	}
	public void setTotalIVASeguroCuota(String totalIVASeguroCuota) {
		this.totalIVASeguroCuota = totalIVASeguroCuota;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}
	
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public String getFechaExigible() {
		return fechaExigible;
	}
	public void setFechaExigible(String fechaExigible) {
		this.fechaExigible = fechaExigible;
	}
	
	public String getSaldoInsoluto() {
		return saldoInsoluto;
	}
	public void setSaldoInsoluto(String saldoInsoluto) {
		this.saldoInsoluto = saldoInsoluto;
	}
	public String getTotalPago() {
		return totalPago;
	}
	public void setTotalPago(String totalPago) {
		this.totalPago = totalPago;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getInteres() {
		return interes;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public String getIvaInteres() {
		return ivaInteres;
	}
	public void setIvaInteres(String ivaInteres) {
		this.ivaInteres = ivaInteres;
	}
	
	public String iVASeguroCuota() {
		return cuotasCapital;
	}
	public void setCuotasCapital(String cuotasCapital) {
		this.cuotasCapital = cuotasCapital;
	}
	public String getCuotasCapital() {
		return cuotasCapital;
	}

	public String getDias() {
		return dias;
	}
	public void setDias(String dias) {
		this.dias = dias;
	}
	
	public String getCat() {
		return cat;
	}
	public void setCat(String cat) {
		this.cat = cat;
	}
	public String getMontoSeguroCuota() {
		return montoSeguroCuota;
	}
	public void setMontoSeguroCuota(String montoSeguroCuota) {
		this.montoSeguroCuota = montoSeguroCuota;
	}
	public String getiVASeguroCuota() {
		return iVASeguroCuota;
	}
	public void setiVASeguroCuota(String iVASeguroCuota) {
		this.iVASeguroCuota = iVASeguroCuota;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}
	public String getCodigoError() {
		return codigoError;
	}
	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}
	public String getMensajeError() {
		return mensajeError;
	}
	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}
	public String getNumTransacSim() {
		return numTransacSim;
	}
	public void setNumTransacSim(String numTransacSim) {
		this.numTransacSim = numTransacSim;
	}
}
	