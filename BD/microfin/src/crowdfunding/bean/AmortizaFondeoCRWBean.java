package crowdfunding.bean;

public class AmortizaFondeoCRWBean {

	private String solFondeoID;
	private String amortizacionID;
	private String fechaInicio;
	private String fechaVencimiento;
	private String fechaExigible;
	private String capital;
	private String interesGenerado;
	private String interesRetener;
	private String porcentajeInteres;
	private String estatus;
	private String saldoCapVigente;
	private String saldoCapExigible;
	private String saldoInteres;
	private String saldoMoratorios;
	private String saldoCapCtaOrden;
	private String saldoIntCtaInt;

	private String provisionAcum;
	private String moratorioPagado;
	private String comFalPagPagada;
	private String intOrdRetenido;
	private String intMorRetenido;
	private String comFalPagRetenido;
	private String totalSalCapital; //para el monto total a recibir, en grid de calendario de inversionistas
	private String totalSalInteres; //para el monto total  en grid de calendario de inversionistas
	private String totalIntMora;
	private String totalCapCO;
	private String totalIntCO;
	private String fechaLiquida;

	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;

	public String getSolFondeoID() {
		return solFondeoID;
	}
	public void setSolFondeoID(String solFondeoID) {
		this.solFondeoID = solFondeoID;
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
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
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
	public String getInteresGenerado() {
		return interesGenerado;
	}
	public void setInteresGenerado(String interesGenerado) {
		this.interesGenerado = interesGenerado;
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
	public String getTotalIntMora() {
		return totalIntMora;
	}
	public void setTotalIntMora(String totalIntMora) {
		this.totalIntMora = totalIntMora;
	}
	public String getTotalCapCO() {
		return totalCapCO;
	}
	public void setTotalCapCO(String totalCapCO) {
		this.totalCapCO = totalCapCO;
	}
	public String getTotalIntCO() {
		return totalIntCO;
	}
	public void setTotalIntCO(String totalIntCO) {
		this.totalIntCO = totalIntCO;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getSaldoCapCtaOrden() {
		return saldoCapCtaOrden;
	}
	public void setSaldoCapCtaOrden(String saldoCapCtaOrden) {
		this.saldoCapCtaOrden = saldoCapCtaOrden;
	}
	public String getSaldoIntCtaInt() {
		return saldoIntCtaInt;
	}
	public void setSaldoIntCtaInt(String saldoIntCtaInt) {
		this.saldoIntCtaInt = saldoIntCtaInt;
	}


}

