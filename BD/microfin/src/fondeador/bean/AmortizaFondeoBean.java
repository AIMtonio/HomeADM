package fondeador.bean;

public class AmortizaFondeoBean {

	private String creditoFondeoID;
	private String amortizacionID;
	private String fechaInicio;
	private String fechaVencim;
	private String fechaExigible;
	private String capital;
	private String interes;
	private String ivaInteres;
	private String interesRetener;
	private String porcentajeInteres;
	private String estatus;
	private String saldoCapVigente;
	private String saldoCapExigible;
	private String saldoInteres;
	private String provisionAcum;
	private String moratorioPagado;
	private String comFalPagPagada;
	private String intOrdRetenido;
	private String intMorRetenido;
	private String comFalPagRetenido;
	private String totalSalCapital; //para el monto total a recibir, en grid de calendario de inversionistas
	private String totalSalInteres; //para el monto total  en grid de calendario de inversionistas
	private String fechaLiquida;
	
	private String saldoCapital;
	private String saldoCapAtrasa;
	private String saldoInteresPro;
	private String saldoInteresAtra;
	private String saldoIVAInteres;
	private String saldoIVAMora;
	private String saldoIVAComFalP;
	private String saldoOtrasComis;
	private String saldoIVAOtrCom;
	private String totalCuota;
	private String saldoRetencion;
		
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	// auxiliares del bean 
	private String totalPago;
	private String saldoInsoluto;
	private String dias; 
	private String capitalInteres;
	private String cuotasCapital;
	private String cuotasInteres;
	private String cat;
	private String fecUltAmor;
	private String fecInicioAmor;
	private String montoCuota;
	private String saldoMoratorios;
	private String saldoComFaltaPago;
	private String saldoOtrasComisiones;
	private String estatusAmortiza;
	private String altaEncPoliza;
	private String retencion;
	private String fechaVencimiento;
	
	
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
	public String getFechaExigible() {
		return fechaExigible;
	}
	public void setFechaExigible(String fechaExigible) {
		this.fechaExigible = fechaExigible;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}

	public String getInteresRetener() {
		return interesRetener;
	}
	public void setInteresRetener(String interesRetener) {
		this.interesRetener = interesRetener;
	}
	public String getPorcentajeInteres() {
		return porcentajeInteres;
	}
	public void setPorcentajeInteres(String porcentajeInteres) {
		this.porcentajeInteres = porcentajeInteres;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSaldoCapVigente() {
		return saldoCapVigente;
	}
	public void setSaldoCapVigente(String saldoCapVigente) {
		this.saldoCapVigente = saldoCapVigente;
	}
	public String getSaldoCapExigible() {
		return saldoCapExigible;
	}
	public void setSaldoCapExigible(String saldoCapExigible) {
		this.saldoCapExigible = saldoCapExigible;
	}
	public String getSaldoInteres() {
		return saldoInteres;
	}
	public void setSaldoInteres(String saldoInteres) {
		this.saldoInteres = saldoInteres;
	}
	public String getProvisionAcum() {
		return provisionAcum;
	}
	public void setProvisionAcum(String provisionAcum) {
		this.provisionAcum = provisionAcum;
	}
	public String getMoratorioPagado() {
		return moratorioPagado;
	}
	public void setMoratorioPagado(String moratorioPagado) {
		this.moratorioPagado = moratorioPagado;
	}
	public String getComFalPagPagada() {
		return comFalPagPagada;
	}
	public void setComFalPagPagada(String comFalPagPagada) {
		this.comFalPagPagada = comFalPagPagada;
	}
	public String getIntOrdRetenido() {
		return intOrdRetenido;
	}
	public void setIntOrdRetenido(String intOrdRetenido) {
		this.intOrdRetenido = intOrdRetenido;
	}
	public String getIntMorRetenido() {
		return intMorRetenido;
	}
	public void setIntMorRetenido(String intMorRetenido) {
		this.intMorRetenido = intMorRetenido;
	}
	public String getComFalPagRetenido() {
		return comFalPagRetenido;
	}
	public void setComFalPagRetenido(String comFalPagRetenido) {
		this.comFalPagRetenido = comFalPagRetenido;
	}
	
	public String getTotalSalCapital() {
		return totalSalCapital;
	}
	public void setTotalSalCapital(String totalSalCapital) {
		this.totalSalCapital = totalSalCapital;
	}
	public String getTotalSalInteres() {
		return totalSalInteres;
	}
	public void setTotalSalInteres(String totalSalInteres) {
		this.totalSalInteres = totalSalInteres;
	}
	public String getFechaLiquida() {
		return fechaLiquida;
	}
	public void setFechaLiquida(String fechaLiquida) {
		this.fechaLiquida = fechaLiquida;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}
	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}
	public String getTotalPago() {
		return totalPago;
	}
	public void setTotalPago(String totalPago) {
		this.totalPago = totalPago;
	}
	public String getSaldoInsoluto() {
		return saldoInsoluto;
	}
	public void setSaldoInsoluto(String saldoInsoluto) {
		this.saldoInsoluto = saldoInsoluto;
	}
	public String getDias() {
		return dias;
	}
	public void setDias(String dias) {
		this.dias = dias;
	}
	public String getCapitalInteres() {
		return capitalInteres;
	}
	public void setCapitalInteres(String capitalInteres) {
		this.capitalInteres = capitalInteres;
	}
	public String getCuotasCapital() {
		return cuotasCapital;
	}
	public void setCuotasCapital(String cuotasCapital) {
		this.cuotasCapital = cuotasCapital;
	}
	public String getCuotasInteres() {
		return cuotasInteres;
	}
	public void setCuotasInteres(String cuotasInteres) {
		this.cuotasInteres = cuotasInteres;
	}
	public String getCat() {
		return cat;
	}
	public void setCat(String cat) {
		this.cat = cat;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
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
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public String getSaldoComFaltaPago() {
		return saldoComFaltaPago;
	}
	public String getSaldoOtrasComisiones() {
		return saldoOtrasComisiones;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public void setSaldoComFaltaPago(String saldoComFaltaPago) {
		this.saldoComFaltaPago = saldoComFaltaPago;
	}
	public void setSaldoOtrasComisiones(String saldoOtrasComisiones) {
		this.saldoOtrasComisiones = saldoOtrasComisiones;
	}
	public String getEstatusAmortiza() {
		return estatusAmortiza;
	}
	public void setEstatusAmortiza(String estatusAmortiza) {
		this.estatusAmortiza = estatusAmortiza;
	}
	public String getAltaEncPoliza() {
		return altaEncPoliza;
	}
	public void setAltaEncPoliza(String altaEncPoliza) {
		this.altaEncPoliza = altaEncPoliza;
	}
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public String getSaldoCapAtrasa() {
		return saldoCapAtrasa;
	}
	public void setSaldoCapAtrasa(String saldoCapAtrasa) {
		this.saldoCapAtrasa = saldoCapAtrasa;
	}
	public String getSaldoInteresPro() {
		return saldoInteresPro;
	}
	public void setSaldoInteresPro(String saldoInteresPro) {
		this.saldoInteresPro = saldoInteresPro;
	}
	public String getSaldoInteresAtra() {
		return saldoInteresAtra;
	}
	public void setSaldoInteresAtra(String saldoInteresAtra) {
		this.saldoInteresAtra = saldoInteresAtra;
	}
	public String getSaldoIVAInteres() {
		return saldoIVAInteres;
	}
	public void setSaldoIVAInteres(String saldoIVAInteres) {
		this.saldoIVAInteres = saldoIVAInteres;
	}
	public String getSaldoIVAMora() {
		return saldoIVAMora;
	}
	public void setSaldoIVAMora(String saldoIVAMora) {
		this.saldoIVAMora = saldoIVAMora;
	}
	public String getSaldoIVAComFalP() {
		return saldoIVAComFalP;
	}
	public void setSaldoIVAComFalP(String saldoIVAComFalP) {
		this.saldoIVAComFalP = saldoIVAComFalP;
	}
	public String getSaldoOtrasComis() {
		return saldoOtrasComis;
	}
	public void setSaldoOtrasComis(String saldoOtrasComis) {
		this.saldoOtrasComis = saldoOtrasComis;
	}
	public String getSaldoIVAOtrCom() {
		return saldoIVAOtrCom;
	}
	public void setSaldoIVAOtrCom(String saldoIVAOtrCom) {
		this.saldoIVAOtrCom = saldoIVAOtrCom;
	}
	public String getTotalCuota() {
		return totalCuota;
	}
	public void setTotalCuota(String totalCuota) {
		this.totalCuota = totalCuota;
	}
	public String getRetencion() {
		return retencion;
	}
	public void setRetencion(String retencion) {
		this.retencion = retencion;
	}
	public String getSaldoRetencion() {
		return saldoRetencion;
	}
	public void setSaldoRetencion(String saldoRetencion) {
		this.saldoRetencion = saldoRetencion;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	
}

