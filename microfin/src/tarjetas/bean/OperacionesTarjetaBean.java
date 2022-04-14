package tarjetas.bean;

import general.bean.BaseBean;

public class OperacionesTarjetaBean  extends BaseBean{

	/* Declaracion de constantes 
	 * corresponden con Campo 2 ISO 8583 de tipo Operacion de ws de operaciones tarjeta*/
	public static String compraNormal = "00"; // Normal Purchase - Compra Normal
	public static String retiroEfectivo = "01"; //Cash Advance - Retiro de Efectivo
	public static String compraRetiroEfectivo = "09"; //compra con Retiro de Efectivo
	public static String ajusteCompra = "02"; //Debit Adjustment - Ajuste de Compra
	public static String checkIn = "04"; // Check In
	public static String propina = "05" ;// Propina
	public static String posPropina = "06"; // PosPropina
	public static String compraConRetiroEfec = "09"; //Purchase with Cashback (See field 54) - Compra con Retiro de Efectivo
	public static String devoluciones = "20" ;// Returns - Devoluciones
	public static String consultaSaldo = "30" ; // Balance inquiry - Consulta de Saldo
	public static String compraElectronica = "80"; //Mail or Phone Order - Compra Electronica Web o Telefonica.
	public static String pago = "25" ; // Payment - Pago
	public static String monedaPesosWS = "484"; // equivale a moneda en pesos
	public static String monedaPesosSafi = "1"; // equivale a moneda en pesos tabla MONEDAS
	
	// tipos de movimientos de la cuenta 
	public static String tipoMovAhoCompraNormal = "17";  // corresponde con la tabla TIPOSMOVSAHO
	public static String tipoMovAhoRetiroEfec = "18"; // corresponde con la tabla TIPOSMOVSAHO
	public static String tipoMovAhoPago = "19"; // corresponde con la tabla TIPOSMOVSAHO
	
	public static String desMovAhoCompraNormal = "COMPRA NORMAL TD";  // corresponde con la tabla TIPOSMOVSAHO
	public static String desMovAhoRetiroEfec = "RETIRO DE EFECTIVO TD"; // corresponde con la tabla TIPOSMOVSAHO
	public static String desMovAhoPago = "PAGO TD"; // corresponde con la tabla TIPOSMOVSAHO
	
	public static String naturalezaCargo = "C"; // indica la naturaleza de cargo del movimiento
	public static String naturalezaAbono = "A"; // indica la naturaleza de abono del movimiento
	

	public static String mensajeExito = "00"; // mensaje de respuesta de exito
	
	// atributos de la tabla 
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
	
	// auxiliares del Bean
	private String naturalezaMovimiento;
	private String saldoActualizado;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String tipoMovAho;
	private String monedaID;

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

	public String getNaturalezaMovimiento() {
		return naturalezaMovimiento;
	}

	public void setNaturalezaMovimiento(String naturalezaMovimiento) {
		this.naturalezaMovimiento = naturalezaMovimiento;
	}

	public String getSaldoActualizado() {
		return saldoActualizado;
	}

	public void setSaldoActualizado(String saldoActualizado) {
		this.saldoActualizado = saldoActualizado;
	}

	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}

	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}

	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}

	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}

	public String getTipoMovAho() {
		return tipoMovAho;
	}

	public void setTipoMovAho(String tipoMovAho) {
		this.tipoMovAho = tipoMovAho;
	}

	public String getMonedaID() {
		return monedaID;
	}

	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}

	public String getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	
}