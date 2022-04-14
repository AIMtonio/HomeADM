package tarjetas.beanWS.request;

import general.bean.BaseBeanWS;

public class OperacionTarjetaRequest extends BaseBeanWS {
	
	private String EmisorID;				// (IssuerID)
	private String MensajeID;				// (MessageID)
	private String TipoOperacion;			// (OperationType)
	private String FechaPeticion;			// (RequestDate)
	private String HoraPeticion;			// (RequestTime)
	
	private String NumeroAfiliacion;		// (AffiliationNumber)
	private String NombreComercio;			// (MerchantName)
	private String NumeroCuenta;			// (AccountNumber)
	private String NumeroTarjeta;			// (CardNumber)
	private String CodigoMoneda;			// (CurrencyCode)
	
	private String MontoTransaccion;		// (TransactionAmount)
	private String MontoAdicional;			// (AditionalAmount)
	private String MontoComision;			// (CommissionAmount)
	private String OriCodigoAutorizacion;	// (OriAuthorizationCode)
	
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
	public String getTipoOperacion() {
		return TipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		TipoOperacion = tipoOperacion;
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
	public String getNumeroAfiliacion() {
		return NumeroAfiliacion;
	}
	public void setNumeroAfiliacion(String numeroAfiliacion) {
		NumeroAfiliacion = numeroAfiliacion;
	}
	public String getNombreComercio() {
		return NombreComercio;
	}
	public void setNombreComercio(String nombreComercio) {
		NombreComercio = nombreComercio;
	}
	public String getNumeroCuenta() {
		return NumeroCuenta;
	}
	public void setNumeroCuenta(String numeroCuenta) {
		NumeroCuenta = numeroCuenta;
	}
	public String getNumeroTarjeta() {
		return NumeroTarjeta;
	}
	public void setNumeroTarjeta(String numeroTarjeta) {
		NumeroTarjeta = numeroTarjeta;
	}
	public String getCodigoMoneda() {
		return CodigoMoneda;
	}
	public void setCodigoMoneda(String codigoMoneda) {
		CodigoMoneda = codigoMoneda;
	}
	public String getMontoTransaccion() {
		return MontoTransaccion;
	}
	public void setMontoTransaccion(String montoTransaccion) {
		MontoTransaccion = montoTransaccion;
	}
	public String getMontoAdicional() {
		return MontoAdicional;
	}
	public void setMontoAdicional(String montoAdicional) {
		MontoAdicional = montoAdicional;
	}
	public String getMontoComision() {
		return MontoComision;
	}
	public void setMontoComision(String montoComision) {
		MontoComision = montoComision;
	}
	public String getOriCodigoAutorizacion() {
		return OriCodigoAutorizacion;
	}
	public void setOriCodigoAutorizacion(String oriCodigoAutorizacion) {
		OriCodigoAutorizacion = oriCodigoAutorizacion;
	}
	
}
