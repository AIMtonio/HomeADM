package fondeador.bean;

import general.bean.BaseBean;

public class RepVencimiPasBean extends BaseBean{
	
	private String		creditoID;
	private String		clienteID;
	private String		nombreCompleto;
	private String		montoCredito;
	private String		fechaInicio;
	private String		fechaVencimien;
	private String		fechaVencim;
	private String		capital;
	private String		interes;
	private String		moratorios;
	private String		comisiones;
	private String		cargos;
	private String		amortizacionID;
	private String		IVATotal;
	private String 		ISR;
	private String		cobraIVAMora;
	private String		cobraIVAInteres;
	private String		sucursalID;
	private String		nombreSucurs;
	private String		productoCreditoID;
	private String		descripcion;
	private String		promotorActual;
	private String		nombrePromotor;
	private String		totalCuota;
	private String		capitalP;
	private String		interesP;
	private String		moratorioPagado;
	private String		ivaPagado;	
	private String		ISRR;	
	private String		pago;
	private String		fechaPago;
	private String		diasAtraso;
	private String		saldoTotal;
	private String 		institucionFondeo;
	private String 		hora;
	private String 		fecha;
	private String 		estatus;
	private String      nombreLinea;
	private String      lineaFondeoID;
	private String      institutFondID;
	private String 		nomMoneda;
	private String		valorDivisa;
	
	
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getInstitucionFondeo() {
		return institucionFondeo;
	}
	public void setInstitucionFondeo(String institucionFondeo) {
		this.institucionFondeo = institucionFondeo;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimien() {
		return fechaVencimien;
	}
	public void setFechaVencimien(String fechaVencimien) {
		this.fechaVencimien = fechaVencimien;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
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
	public String getMoratorios() {
		return moratorios;
	}
	public void setMoratorios(String moratorios) {
		this.moratorios = moratorios;
	}
	public String getComisiones() {
		return comisiones;
	}
	public void setComisiones(String comisiones) {
		this.comisiones = comisiones;
	}
	public String getCargos() {
		return cargos;
	}
	public void setCargos(String cargos) {
		this.cargos = cargos;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}
	public String getIVATotal() {
		return IVATotal;
	}
	public void setIVATotal(String iVATotal) {
		IVATotal = iVATotal;
	}
	public String getCobraIVAMora() {
		return cobraIVAMora;
	}
	public void setCobraIVAMora(String cobraIVAMora) {
		this.cobraIVAMora = cobraIVAMora;
	}
	public String getCobraIVAInteres() {
		return cobraIVAInteres;
	}
	public void setCobraIVAInteres(String cobraIVAInteres) {
		this.cobraIVAInteres = cobraIVAInteres;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getPromotorActual() {
		return promotorActual;
	}
	public void setPromotorActual(String promotorActual) {
		this.promotorActual = promotorActual;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getTotalCuota() {
		return totalCuota;
	}
	public void setTotalCuota(String totalCuota) {
		this.totalCuota = totalCuota;
	}
	public String getPago() {
		return pago;
	}
	public void setPago(String pago) {
		this.pago = pago;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getSaldoTotal() {
		return saldoTotal;
	}
	public void setSaldoTotal(String saldoTotal) {
		this.saldoTotal = saldoTotal;
	}
	public String getNombreLinea() {
		return nombreLinea;
	}
	public void setNombreLinea(String nombreLinea) {
		this.nombreLinea = nombreLinea;
	}
	public String getLineaFondeoID() {
		return lineaFondeoID;
	}
	public void setLineaFondeoID(String lineaFondeoID) {
		this.lineaFondeoID = lineaFondeoID;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public String getISR() {
		return ISR;
	}
	public String getCapitalP() {
		return capitalP;
	}
	public String getInteresP() {
		return interesP;
	}
	public String getISRR() {
		return ISRR;
	}
	public void setISR(String iSR) {
		ISR = iSR;
	}
	public void setCapitalP(String capitalP) {
		this.capitalP = capitalP;
	}
	public void setInteresP(String interesP) {
		this.interesP = interesP;
	}
	public void setISRR(String iSRR) {
		ISRR = iSRR;
	}
	public String getMoratorioPagado() {
		return moratorioPagado;
	}
	public void setMoratorioPagado(String moratorioPagado) {
		this.moratorioPagado = moratorioPagado;
	}
	public String getIvaPagado() {
		return ivaPagado;
	}
	public void setIvaPagado(String ivaPagado) {
		this.ivaPagado = ivaPagado;
	}
	public String getNomMoneda() {
		return nomMoneda;
	}
	public void setNomMoneda(String nomMoneda) {
		this.nomMoneda = nomMoneda;
	}
	public String getValorDivisa() {
		return valorDivisa;
	}
	public void setValorDivisa(String valorDivisa) {
		this.valorDivisa = valorDivisa;
	}
	
	

}
