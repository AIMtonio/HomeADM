package credito.bean;

import general.bean.BaseBean;

public class DetallePagoBean extends BaseBean{

	private String montoTotal;
	private String capital;	
	private String interes;
	private String montoIntMora;
	private String montoIVA;
	private String montoComision;
	private String totalPago;
	private String totalAdeudo;

	private String montoPagado;
	private String proximaFechaPago;
	private String hora;
	private String transaccion;
	private String clienteID;
	private String nombreCompelto;
	private String capitalInsoluto;
	
	private String creditoID;
	private String fechaPago;
	
	private String montoGastoAdmon;
	private String totalDeudaPend;
	//SEGUROS
	private String cobraSeguroCuota;
	private String montoSeguroCuota;
	private String iVASeguroCuota;
	//COMISION ANUAL
	private String saldoComAnual; //Comision de anualidad de crédito
	private String saldoComAnualIVA;//IVA Comision de anualidad de crédito
	
	public String getMontoTotal() {
		return montoTotal;
	}
	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
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
	public String getMontoIntMora() {
		return montoIntMora;
	}
	public void setMontoIntMora(String montoIntMora) {
		this.montoIntMora = montoIntMora;
	}
	public String getMontoIVA() {
		return montoIVA;
	}
	public void setMontoIVA(String montoIVA) {
		this.montoIVA = montoIVA;
	}
	public String getMontoComision() {
		return montoComision;
	}
	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	public String getTotalPago() {
		return totalPago;
	}
	public void setTotalPago(String totalPago) {
		this.totalPago = totalPago;
	}
	public String getTotalAdeudo() {
		return totalAdeudo;
	}
	public void setTotalAdeudo(String totalAdeudo) {
		this.totalAdeudo = totalAdeudo;
	}
	public String getMontoPagado() {
		return montoPagado;
	}
	public void setMontoPagado(String montoPagado) {
		this.montoPagado = montoPagado;
	}
	public String getProximaFechaPago() {
		return proximaFechaPago;
	}
	public void setProximaFechaPago(String proximaFechaPago) {
		this.proximaFechaPago = proximaFechaPago;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getTransaccion() {
		return transaccion;
	}
	public void setTransaccion(String transaccion) {
		this.transaccion = transaccion;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompelto() {
		return nombreCompelto;
	}
	public void setNombreCompelto(String nombreCompelto) {
		this.nombreCompelto = nombreCompelto;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getMontoGastoAdmon() {
		return montoGastoAdmon;
	}
	public void setMontoGastoAdmon(String montoGastoAdmon) {
		this.montoGastoAdmon = montoGastoAdmon;
	}
	public String getTotalDeudaPend() {
		return totalDeudaPend;
	}
	public void setTotalDeudaPend(String totalDeudaPend) {
		this.totalDeudaPend = totalDeudaPend;
	}
	public String getCapitalInsoluto() {
		return capitalInsoluto;
	}
	public void setCapitalInsoluto(String capitalInsoluto) {
		this.capitalInsoluto = capitalInsoluto;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
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
	public String getSaldoComAnual() {
		return saldoComAnual;
	}
	public void setSaldoComAnual(String saldoComAnual) {
		this.saldoComAnual = saldoComAnual;
	}
	public String getSaldoComAnualIVA() {
		return saldoComAnualIVA;
	}
	public void setSaldoComAnualIVA(String saldoComAnualIVA) {
		this.saldoComAnualIVA = saldoComAnualIVA;
	}
}
