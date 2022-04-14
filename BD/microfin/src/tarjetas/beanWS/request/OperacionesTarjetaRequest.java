package tarjetas.beanWS.request;

import general.bean.BaseBeanWS;

public class OperacionesTarjetaRequest  extends BaseBeanWS{
	private String tipoOperacion;
	private String numeroTarjeta;
	private String origenInstrumento;
	private String montoTransaccion;
	private String fechaHoraOperacion;
	private String numeroTransaccion;
	private String giroNegocio;
	private String puntoEntrada;
	private String idTerminal;
	private String nombreUbicacionTerminal;
	private String nip;
	private String codigoMonedaoperacion;
	private String montosAdicionales;
	private String montoSurcharge;
	private String montoLoyaltyfee;
	private String fechaVencimiento;
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getNumeroTarjeta() {
		return numeroTarjeta;
	}
	public void setNumeroTarjeta(String numeroTarjeta) {
		this.numeroTarjeta = numeroTarjeta;
	}
	public String getOrigenInstrumento() {
		return origenInstrumento;
	}
	public void setOrigenInstrumento(String origenInstrumento) {
		this.origenInstrumento = origenInstrumento;
	}
	public String getMontoTransaccion() {
		return montoTransaccion;
	}
	public void setMontoTransaccion(String montoTransaccion) {
		this.montoTransaccion = montoTransaccion;
	}
	public String getFechaHoraOperacion() {
		return fechaHoraOperacion;
	}
	public void setFechaHoraOperacion(String fechaHoraOperacion) {
		this.fechaHoraOperacion = fechaHoraOperacion;
	}
	public String getNumeroTransaccion() {
		return numeroTransaccion;
	}
	public void setNumeroTransaccion(String numeroTransaccion) {
		this.numeroTransaccion = numeroTransaccion;
	}
	public String getGiroNegocio() {
		return giroNegocio;
	}
	public void setGiroNegocio(String giroNegocio) {
		this.giroNegocio = giroNegocio;
	}
	public String getPuntoEntrada() {
		return puntoEntrada;
	}
	public void setPuntoEntrada(String puntoEntrada) {
		this.puntoEntrada = puntoEntrada;
	}
	public String getIdTerminal() {
		return idTerminal;
	}
	public void setIdTerminal(String idTerminal) {
		this.idTerminal = idTerminal;
	}
	public String getNombreUbicacionTerminal() {
		return nombreUbicacionTerminal;
	}
	public void setNombreUbicacionTerminal(String nombreUbicacionTerminal) {
		this.nombreUbicacionTerminal = nombreUbicacionTerminal;
	}
	public String getNip() {
		return nip;
	}
	public void setNip(String nip) {
		this.nip = nip;
	}
	public String getCodigoMonedaoperacion() {
		return codigoMonedaoperacion;
	}
	public void setCodigoMonedaoperacion(String codigoMonedaoperacion) {
		this.codigoMonedaoperacion = codigoMonedaoperacion;
	}
	public String getMontosAdicionales() {
		return montosAdicionales;
	}
	public void setMontosAdicionales(String montosAdicionales) {
		this.montosAdicionales = montosAdicionales;
	}
	public String getMontoSurcharge() {
		return montoSurcharge;
	}
	public void setMontoSurcharge(String montoSurcharge) {
		this.montoSurcharge = montoSurcharge;
	}
	public String getMontoLoyaltyfee() {
		return montoLoyaltyfee;
	}
	public void setMontoLoyaltyfee(String montoLoyaltyfee) {
		this.montoLoyaltyfee = montoLoyaltyfee;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
}