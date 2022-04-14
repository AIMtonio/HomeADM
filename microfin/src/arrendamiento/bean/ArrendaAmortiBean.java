package arrendamiento.bean;

import general.bean.BaseBean;

public class ArrendaAmortiBean extends BaseBean{
	// ATRIBUTOS DE LA TABLA 
	private String arrendaAmortiID;
	private String arrendaID;
	private String clienteID;
	private String fechaInicio;
	private String fechaVencim;
	private String fechaExigible;
	private String fechaLiquida;
	private String estatus;
	private String capitalRenta;
	private String interesRenta;
	private String renta;
	private String ivaRenta;
	private String saldoInsoluto;
	private String seguro;
	private String seguroVida;
	private String saldoCapVigent;
	private String saldoCapAtrasad;
	private String saldoCapVencido;
	private String montoIVACapital;
	private String saldoInteresVigente;
	private String saldoInteresAtras;
	private String saldoInteresVen;
	private String montoIVAInteres;
	private String saldoSeguro;
	private String montoIVASeguro;
	private String saldoSeguroVida;
	private String montoIVASeguroVida;
	private String saldoMoratorios;
	private String montoIVAMora;
	private String saldComFaltPago;
	private String montoIVAComFalPag;
	private String saldoOtrasComis;
	private String montoIVAComisi;
	private String ivaSeguro;
	private String ivaSeguroVida;
	
	// CAMPOS DE APOYO PARA EL SIMULADOR DE PAGOS 
	private String saldoCapital;
	private String pagoTotal;
	private String codigoError;
	private String mensajeError;
	private String numeroCuotas;
	private String montoCuota;
	private String fechaPrimerVen;
	private String fechaUltimoVen;
	private String totalCapital;
	private String totalInteres;
	private String totalIva;
	private String totalRenta;
	private String totalPago;
	
	// CAMPOS PARA PANTALLA DE PAGOS
	private String totalComision;
	private String totalIvaComisi;
	private String totalExigible;
	
	// CAMPOS DE AUDITORIA 
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	public String getFechaPrimerVen() {
		return fechaPrimerVen;
	}
	public void setFechaPrimerVen(String fechaPrimerVen) {
		this.fechaPrimerVen = fechaPrimerVen;
	}
	public String getFechaUltimoVen() {
		return fechaUltimoVen;
	}
	public void setFechaUltimoVen(String fechaUltimoVen) {
		this.fechaUltimoVen = fechaUltimoVen;
	}
	public String getTotalCapital() {
		return totalCapital;
	}
	public void setTotalCapital(String totalCapital) {
		this.totalCapital = totalCapital;
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
	public String getTotalRenta() {
		return totalRenta;
	}
	public void setTotalRenta(String totalRenta) {
		this.totalRenta = totalRenta;
	}
	public String getTotalPago() {
		return totalPago;
	}
	public void setTotalPago(String totalPago) {
		this.totalPago = totalPago;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getNumeroCuotas() {
		return numeroCuotas;
	}
	public void setNumeroCuotas(String numeroCuotas) {
		this.numeroCuotas = numeroCuotas;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getPagoTotal() {
		return pagoTotal;
	}
	public void setPagoTotal(String pagoTotal) {
		this.pagoTotal = pagoTotal;
	}
	public String getArrendaAmortiID() {
		return arrendaAmortiID;
	}
	public void setArrendaAmortiID(String arrendaAmortiID) {
		this.arrendaAmortiID = arrendaAmortiID;
	}
	public String getArrendaID() {
		return arrendaID;
	}
	public void setArrendaID(String arrendaID) {
		this.arrendaID = arrendaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
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
	public String getFechaLiquida() {
		return fechaLiquida;
	}
	public void setFechaLiquida(String fechaLiquida) {
		this.fechaLiquida = fechaLiquida;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCapitalRenta() {
		return capitalRenta;
	}
	public void setCapitalRenta(String capitalRenta) {
		this.capitalRenta = capitalRenta;
	}
	public String getInteresRenta() {
		return interesRenta;
	}
	public void setInteresRenta(String interesRenta) {
		this.interesRenta = interesRenta;
	}
	public String getRenta() {
		return renta;
	}
	public void setRenta(String renta) {
		this.renta = renta;
	}
	public String getIvaRenta() {
		return ivaRenta;
	}
	public void setIvaRenta(String ivaRenta) {
		this.ivaRenta = ivaRenta;
	}
	public String getSaldoInsoluto() {
		return saldoInsoluto;
	}
	public void setSaldoInsoluto(String saldoInsoluto) {
		this.saldoInsoluto = saldoInsoluto;
	}
	public String getSeguro() {
		return seguro;
	}
	public void setSeguro(String seguro) {
		this.seguro = seguro;
	}
	public String getSeguroVida() {
		return seguroVida;
	}
	public void setSeguroVida(String seguroVida) {
		this.seguroVida = seguroVida;
	}
	public String getSaldoCapVigent() {
		return saldoCapVigent;
	}
	public void setSaldoCapVigent(String saldoCapVigent) {
		this.saldoCapVigent = saldoCapVigent;
	}
	public String getSaldoCapAtrasad() {
		return saldoCapAtrasad;
	}
	public void setSaldoCapAtrasad(String saldoCapAtrasad) {
		this.saldoCapAtrasad = saldoCapAtrasad;
	}
	public String getSaldoCapVencido() {
		return saldoCapVencido;
	}
	public void setSaldoCapVencido(String saldoCapVencido) {
		this.saldoCapVencido = saldoCapVencido;
	}
	public String getMontoIVACapital() {
		return montoIVACapital;
	}
	public void setMontoIVACapital(String montoIVACapital) {
		this.montoIVACapital = montoIVACapital;
	}
	public String getSaldoInteresVigente() {
		return saldoInteresVigente;
	}
	public void setSaldoInteresVigente(String saldoInteresVigente) {
		this.saldoInteresVigente = saldoInteresVigente;
	}
	public String getSaldoInteresAtras() {
		return saldoInteresAtras;
	}
	public void setSaldoInteresAtras(String saldoInteresAtras) {
		this.saldoInteresAtras = saldoInteresAtras;
	}
	public String getSaldoInteresVen() {
		return saldoInteresVen;
	}
	public void setSaldoInteresVen(String saldoInteresVen) {
		this.saldoInteresVen = saldoInteresVen;
	}
	public String getMontoIVAInteres() {
		return montoIVAInteres;
	}
	public void setMontoIVAInteres(String montoIVAInteres) {
		this.montoIVAInteres = montoIVAInteres;
	}
	public String getSaldoSeguro() {
		return saldoSeguro;
	}
	public void setSaldoSeguro(String saldoSeguro) {
		this.saldoSeguro = saldoSeguro;
	}
	public String getMontoIVASeguro() {
		return montoIVASeguro;
	}
	public void setMontoIVASeguro(String montoIVASeguro) {
		this.montoIVASeguro = montoIVASeguro;
	}
	public String getSaldoSeguroVida() {
		return saldoSeguroVida;
	}
	public void setSaldoSeguroVida(String saldoSeguroVida) {
		this.saldoSeguroVida = saldoSeguroVida;
	}
	public String getMontoIVASeguroVida() {
		return montoIVASeguroVida;
	}
	public void setMontoIVASeguroVida(String montoIVASeguroVida) {
		this.montoIVASeguroVida = montoIVASeguroVida;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getMontoIVAMora() {
		return montoIVAMora;
	}
	public void setMontoIVAMora(String montoIVAMora) {
		this.montoIVAMora = montoIVAMora;
	}
	public String getSaldComFaltPago() {
		return saldComFaltPago;
	}
	public void setSaldComFaltPago(String saldComFaltPago) {
		this.saldComFaltPago = saldComFaltPago;
	}
	public String getMontoIVAComFalPag() {
		return montoIVAComFalPag;
	}
	public void setMontoIVAComFalPag(String montoIVAComFalPag) {
		this.montoIVAComFalPag = montoIVAComFalPag;
	}
	public String getSaldoOtrasComis() {
		return saldoOtrasComis;
	}
	public void setSaldoOtrasComis(String saldoOtrasComis) {
		this.saldoOtrasComis = saldoOtrasComis;
	}
	public String getMontoIVAComisi() {
		return montoIVAComisi;
	}
	public void setMontoIVAComisi(String montoIVAComisi) {
		this.montoIVAComisi = montoIVAComisi;
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
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}

	public String getTotalComision() {
		return totalComision;
	}
	public void setTotalComision(String totalComision) {
		this.totalComision = totalComision;
	}
	public String getTotalIvaComisi() {
		return totalIvaComisi;
	}
	public void setTotalIvaComisi(String totalIvaComisi) {
		this.totalIvaComisi = totalIvaComisi;
	}
	public String getTotalExigible() {
		return totalExigible;
	}
	public void setTotalExigible(String totalExigible) {
		this.totalExigible = totalExigible;
	}
	
	public String getIvaSeguro() {
		return ivaSeguro;
	}
	public void setIvaSeguro(String ivaSeguro) {
		this.ivaSeguro = ivaSeguro;
	}
	public String getIvaSeguroVida() {
		return ivaSeguroVida;
	}
	public void setIvaSeguroVida(String ivaSeguroVida) {
		this.ivaSeguroVida = ivaSeguroVida;

	}
}
