package tarjetas.beanWS.response;

import general.bean.BaseBeanWS;

public class OperacionPeticionResponse extends BaseBeanWS {

	private String EmisorID;			// (IssuerID)
	private String MensajeID;			// (MessageID)
	private String TipoOperacion;		// (OperationType)
	private String ResultadoOperacion;	// (OperationResult)
	private String EstatusOperacion;	// (OperationStatus)
	
	private String FechaRespuesta;		// (ResponseDate)
	private String HoraRespuesta;		// (ResponseTime)
	private String CodigoRespuesta;		// (ResponseCode)
	private String CodigoAutorizacion;	// (AuthorizationCode)
	private String CodigoRechazo;		// (RejectCode)
	
	private String MensajeRechazo;		// (RejectMessage)
	private String NumeroCuenta;		// (AccountNumber)
	private String NumeroTarjeta;		// (CardNumber)
	private String MontoTransaccion;	// (TransactionAmount)
	private String MontoComision;		// (CommissionAmount)
	
	private String SaldoDisponible;		// (AvailableBalance)
	private String Exception;

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

	public String getResultadoOperacion() {
		return ResultadoOperacion;
	}

	public void setResultadoOperacion(String resultadoOperacion) {
		ResultadoOperacion = resultadoOperacion;
	}

	public String getEstatusOperacion() {
		return EstatusOperacion;
	}

	public void setEstatusOperacion(String estatusOperacion) {
		EstatusOperacion = estatusOperacion;
	}

	public String getFechaRespuesta() {
		return FechaRespuesta;
	}

	public void setFechaRespuesta(String fechaRespuesta) {
		FechaRespuesta = fechaRespuesta;
	}

	public String getHoraRespuesta() {
		return HoraRespuesta;
	}

	public void setHoraRespuesta(String horaRespuesta) {
		HoraRespuesta = horaRespuesta;
	}

	public String getCodigoRespuesta() {
		return CodigoRespuesta;
	}

	public void setCodigoRespuesta(String codigoRespuesta) {
		CodigoRespuesta = codigoRespuesta;
	}

	public String getCodigoAutorizacion() {
		return CodigoAutorizacion;
	}

	public void setCodigoAutorizacion(String codigoAutorizacion) {
		CodigoAutorizacion = codigoAutorizacion;
	}

	public String getCodigoRechazo() {
		return CodigoRechazo;
	}

	public void setCodigoRechazo(String codigoRechazo) {
		CodigoRechazo = codigoRechazo;
	}

	public String getMensajeRechazo() {
		return MensajeRechazo;
	}

	public void setMensajeRechazo(String mensajeRechazo) {
		MensajeRechazo = mensajeRechazo;
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

	public String getMontoTransaccion() {
		return MontoTransaccion;
	}

	public void setMontoTransaccion(String montoTransaccion) {
		MontoTransaccion = montoTransaccion;
	}

	public String getMontoComision() {
		return MontoComision;
	}

	public void setMontoComision(String montoComision) {
		MontoComision = montoComision;
	}

	public String getSaldoDisponible() {
		return SaldoDisponible;
	}

	public void setSaldoDisponible(String saldoDisponible) {
		SaldoDisponible = saldoDisponible;
	}

	public String getException() {
		return Exception;
	}

	public void setException(String exception) {
		Exception = exception;
	}	
}
