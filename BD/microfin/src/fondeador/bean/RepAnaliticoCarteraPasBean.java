package fondeador.bean;

import general.bean.BaseBean;

public class RepAnaliticoCarteraPasBean extends BaseBean{
	
	private String	creditoFondeoID;
	private String	institutFondID;
	private String	nombreInstitFon;
	private String	lineaFondeoID;
	private String	descripLinea;
	private String	monedaID;
	private String	estatusCredito;
	private String	montoCredito;
	private String	numAmortizacion;
	private String	saldoCapVigente;
	private String	saldoCapAtras;
	private String	saldoInteresPro;
	private String	saldoInteresAtra;
	private String	saldoMoratorios;
	private String	saldoComFaltaPa;
	private String	saldoOtrasCom;
	private String	salIVAInteres;
	private String	salIVAMoratorios;
	private String	salIVAComFalPago;
	private String	salIVACom;
	private String	salRetencion;
	private String	pasoCapAtraDia;
	private String	pasoIntAtraDia;
	private String	intOrdDevengado;
	private String	intMorDevengado;
	private String	comisiDevengado;
	private String	pagoCapVigDia;
	private String	pagoCapAtrDia;
	private String	pagoIntOrdDia;
	private String	pagoIntAtrDia;
	private String	pagoComisiDia;
	private String	pagoMoratorios;
	private String	pagoIvaDia;
	private String	ISRDelDia;
	private String	diasAtraso;
	private String	HoraEmision;
	

	private String creditoID;
	private String nombreCompleto;
	private String fechaMinistrado;
	private String fechaProxPag;
	private String montoProx;
	private String fechaUltVenc;
	private String tasaFija;
	private String numSocios;
	private String manejaCarteraAgro;
	
	private String descMoneda;
	private String valoMoneda;
	
	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public String getNombreInstitFon() {
		return nombreInstitFon;
	}
	public String getLineaFondeoID() {
		return lineaFondeoID;
	}
	public String getDescripLinea() {
		return descripLinea;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public String getEstatusCredito() {
		return estatusCredito;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public String getNumAmortizacion() {
		return numAmortizacion;
	}
	public String getSaldoCapVigente() {
		return saldoCapVigente;
	}
	public String getSaldoCapAtras() {
		return saldoCapAtras;
	}
	public String getSaldoInteresPro() {
		return saldoInteresPro;
	}
	public String getSaldoInteresAtra() {
		return saldoInteresAtra;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public String getSaldoComFaltaPa() {
		return saldoComFaltaPa;
	}
	public String getSaldoOtrasCom() {
		return saldoOtrasCom;
	}
	public String getSalIVAInteres() {
		return salIVAInteres;
	}
	public String getSalIVAMoratorios() {
		return salIVAMoratorios;
	}
	public String getSalIVAComFalPago() {
		return salIVAComFalPago;
	}
	public String getSalIVACom() {
		return salIVACom;
	}
	public String getSalRetencion() {
		return salRetencion;
	}
	public String getPasoCapAtraDia() {
		return pasoCapAtraDia;
	}
	public String getPasoIntAtraDia() {
		return pasoIntAtraDia;
	}
	public String getIntOrdDevengado() {
		return intOrdDevengado;
	}
	public String getIntMorDevengado() {
		return intMorDevengado;
	}
	public String getComisiDevengado() {
		return comisiDevengado;
	}
	public String getPagoCapVigDia() {
		return pagoCapVigDia;
	}
	public String getPagoCapAtrDia() {
		return pagoCapAtrDia;
	}
	public String getPagoIntOrdDia() {
		return pagoIntOrdDia;
	}
	public String getPagoIntAtrDia() {
		return pagoIntAtrDia;
	}
	public String getPagoComisiDia() {
		return pagoComisiDia;
	}
	public String getPagoMoratorios() {
		return pagoMoratorios;
	}
	public String getPagoIvaDia() {
		return pagoIvaDia;
	}
	public String getISRDelDia() {
		return ISRDelDia;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public void setNombreInstitFon(String nombreInstitFon) {
		this.nombreInstitFon = nombreInstitFon;
	}
	public void setLineaFondeoID(String lineaFondeoID) {
		this.lineaFondeoID = lineaFondeoID;
	}
	public void setDescripLinea(String descripLinea) {
		this.descripLinea = descripLinea;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public void setEstatusCredito(String estatusCredito) {
		this.estatusCredito = estatusCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public void setNumAmortizacion(String numAmortizacion) {
		this.numAmortizacion = numAmortizacion;
	}
	public void setSaldoCapVigente(String saldoCapVigente) {
		this.saldoCapVigente = saldoCapVigente;
	}
	public void setSaldoCapAtras(String saldoCapAtras) {
		this.saldoCapAtras = saldoCapAtras;
	}
	public void setSaldoInteresPro(String saldoInteresPro) {
		this.saldoInteresPro = saldoInteresPro;
	}
	public void setSaldoInteresAtra(String saldoInteresAtra) {
		this.saldoInteresAtra = saldoInteresAtra;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public void setSaldoComFaltaPa(String saldoComFaltaPa) {
		this.saldoComFaltaPa = saldoComFaltaPa;
	}
	public void setSaldoOtrasCom(String saldoOtrasCom) {
		this.saldoOtrasCom = saldoOtrasCom;
	}
	public void setSalIVAInteres(String salIVAInteres) {
		this.salIVAInteres = salIVAInteres;
	}
	public void setSalIVAMoratorios(String salIVAMoratorios) {
		this.salIVAMoratorios = salIVAMoratorios;
	}
	public void setSalIVAComFalPago(String salIVAComFalPago) {
		this.salIVAComFalPago = salIVAComFalPago;
	}
	public void setSalIVACom(String salIVACom) {
		this.salIVACom = salIVACom;
	}
	public void setSalRetencion(String salRetencion) {
		this.salRetencion = salRetencion;
	}
	public void setPasoCapAtraDia(String pasoCapAtraDia) {
		this.pasoCapAtraDia = pasoCapAtraDia;
	}
	public void setPasoIntAtraDia(String pasoIntAtraDia) {
		this.pasoIntAtraDia = pasoIntAtraDia;
	}
	public void setIntOrdDevengado(String intOrdDevengado) {
		this.intOrdDevengado = intOrdDevengado;
	}
	public void setIntMorDevengado(String intMorDevengado) {
		this.intMorDevengado = intMorDevengado;
	}
	public void setComisiDevengado(String comisiDevengado) {
		this.comisiDevengado = comisiDevengado;
	}
	public void setPagoCapVigDia(String pagoCapVigDia) {
		this.pagoCapVigDia = pagoCapVigDia;
	}
	public void setPagoCapAtrDia(String pagoCapAtrDia) {
		this.pagoCapAtrDia = pagoCapAtrDia;
	}
	public void setPagoIntOrdDia(String pagoIntOrdDia) {
		this.pagoIntOrdDia = pagoIntOrdDia;
	}
	public void setPagoIntAtrDia(String pagoIntAtrDia) {
		this.pagoIntAtrDia = pagoIntAtrDia;
	}
	public void setPagoComisiDia(String pagoComisiDia) {
		this.pagoComisiDia = pagoComisiDia;
	}
	public void setPagoMoratorios(String pagoMoratorios) {
		this.pagoMoratorios = pagoMoratorios;
	}
	public void setPagoIvaDia(String pagoIvaDia) {
		this.pagoIvaDia = pagoIvaDia;
	}
	public void setISRDelDia(String iSRDelDia) {
		ISRDelDia = iSRDelDia;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getHoraEmision() {
		return HoraEmision;
	}
	public void setHoraEmision(String horaEmision) {
		HoraEmision = horaEmision;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getFechaMinistrado() {
		return fechaMinistrado;
	}
	public void setFechaMinistrado(String fechaMinistrado) {
		this.fechaMinistrado = fechaMinistrado;
	}
	public String getFechaProxPag() {
		return fechaProxPag;
	}
	public void setFechaProxPag(String fechaProxPag) {
		this.fechaProxPag = fechaProxPag;
	}
	public String getMontoProx() {
		return montoProx;
	}
	public void setMontoProx(String montoProx) {
		this.montoProx = montoProx;
	}
	public String getFechaUltVenc() {
		return fechaUltVenc;
	}
	public void setFechaUltVenc(String fechaUltVenc) {
		this.fechaUltVenc = fechaUltVenc;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getNumSocios() {
		return numSocios;
	}
	public void setNumSocios(String numSocios) {
		this.numSocios = numSocios;
	}
	public String getManejaCarteraAgro() {
		return manejaCarteraAgro;
	}
	public void setManejaCarteraAgro(String manejaCarteraAgro) {
		this.manejaCarteraAgro = manejaCarteraAgro;
	}
	public String getDescMoneda() {
		return descMoneda;
	}
	public void setDescMoneda(String descMoneda) {
		this.descMoneda = descMoneda;
	}
	public String getValoMoneda() {
		return valoMoneda;
	}
	public void setValoMoneda(String valoMoneda) {
		this.valoMoneda = valoMoneda;
	}
	
	
}
