package tarjetas.beanWS.request;

import general.bean.BaseBeanWS;

public class TarjetaPeticionRequest extends BaseBeanWS {

	private String EmisorID;				//  (IssuerID)
	private String MensajeID;				//  (MessageID)
	private String ComandoID;				//  (CommandID)
	private String FechaPeticion;			// (RequestDate)
	private String HoraPeticion;			// (RequestTime)
	
	private String NumeroTarjeta;			// (CardNumber)
	private String NumeroProxy;				// (ProxyNumber )
	private String NumeroCuenta;			// (AccountNumber)
	private String NombreTarjeta;			// (CardName)
	private String EstatusTarjeta;			// (CardStatus)
	
	private String LimiteDisposicionDiario;	// (DailyDispositionLimit)
	private String LimiteComprasDiario;		// (DailyPurchasingLimit)
	private String LimiteDisposicionMensual;// (MonthlyDispositionLimit)
	private String LimiteComprasMensual;	// (MonthlyPurchasingLimit)
	private String NumeroDisposicionesXDia;	// (WithdrawsXDayCount)
	
	public String getEmisorID() {
		return EmisorID;
	}
	public void setEmisorID(String emisorID) {
		EmisorID = emisorID;
	}
	public String getMensajeID() {
		return MensajeID;
	}
	public void setMensajeID(String mensajeID) {
		MensajeID = mensajeID;
	}
	public String getComandoID() {
		return ComandoID;
	}
	public void setComandoID(String comandoID) {
		ComandoID = comandoID;
	}
	public String getFechaPeticion() {
		return FechaPeticion;
	}
	public void setFechaPeticion(String fechaPeticion) {
		FechaPeticion = fechaPeticion;
	}
	public String getHoraPeticion() {
		return HoraPeticion;
	}
	public void setHoraPeticion(String horaPeticion) {
		HoraPeticion = horaPeticion;
	}
	public String getNumeroTarjeta() {
		return NumeroTarjeta;
	}
	public void setNumeroTarjeta(String numeroTarjeta) {
		NumeroTarjeta = numeroTarjeta;
	}
	public String getNumeroProxy() {
		return NumeroProxy;
	}
	public void setNumeroProxy(String numeroProxy) {
		NumeroProxy = numeroProxy;
	}
	public String getNumeroCuenta() {
		return NumeroCuenta;
	}
	public void setNumeroCuenta(String numeroCuenta) {
		NumeroCuenta = numeroCuenta;
	}
	public String getNombreTarjeta() {
		return NombreTarjeta;
	}
	public void setNombreTarjeta(String nombreTarjeta) {
		NombreTarjeta = nombreTarjeta;
	}
	public String getEstatusTarjeta() {
		return EstatusTarjeta;
	}
	public void setEstatusTarjeta(String estatusTarjeta) {
		EstatusTarjeta = estatusTarjeta;
	}
	public String getLimiteDisposicionDiario() {
		return LimiteDisposicionDiario;
	}
	public void setLimiteDisposicionDiario(String limiteDisposicionDiario) {
		LimiteDisposicionDiario = limiteDisposicionDiario;
	}
	public String getLimiteComprasDiario() {
		return LimiteComprasDiario;
	}
	public void setLimiteComprasDiario(String limiteComprasDiario) {
		LimiteComprasDiario = limiteComprasDiario;
	}
	public String getLimiteDisposicionMensual() {
		return LimiteDisposicionMensual;
	}
	public void setLimiteDisposicionMensual(String limiteDisposicionMensual) {
		LimiteDisposicionMensual = limiteDisposicionMensual;
	}
	public String getLimiteComprasMensual() {
		return LimiteComprasMensual;
	}
	public void setLimiteComprasMensual(String limiteComprasMensual) {
		LimiteComprasMensual = limiteComprasMensual;
	}
	public String getNumeroDisposicionesXDia() {
		return NumeroDisposicionesXDia;
	}
	public void setNumeroDisposicionesXDia(String numeroDisposicionesXDia) {
		NumeroDisposicionesXDia = numeroDisposicionesXDia;
	}
}
