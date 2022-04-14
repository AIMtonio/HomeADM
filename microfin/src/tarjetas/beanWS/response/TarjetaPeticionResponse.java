package tarjetas.beanWS.response;

import general.bean.BaseBeanWS;

public class TarjetaPeticionResponse extends BaseBeanWS {

	private String EmisorID;			// (IssuerID);
	private String MensajeID;			// (MessageID);
	private String ComandoID;			// (CommandID);
	private String ResultadoOperacion;	// (OperationResult);
	private String FechaRespuesta;		// (ResponseDate);
	
	private String HoraRespuesta;		// (ResponseTime);
	private String CodigoRechazo;		// (RejectCode);
	private String MensajeRechazo;		// (RejectMessage);
	private String NumeroTarjeta;		// (CardNumber);
	private String NumeroProxy;			// (ProxyNumber);
	
	private String NumeroCuenta;		// (AccountNumber);
	private String EstatusTarjeta;		// (CardStatus);
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
	public String getComandoID() {
		return ComandoID;
	}
	public void setComandoID(String comandoID) {
		ComandoID = comandoID;
	}
	public String getResultadoOperacion() {
		return ResultadoOperacion;
	}
	public void setResultadoOperacion(String resultadoOperacion) {
		ResultadoOperacion = resultadoOperacion;
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
	public String getEstatusTarjeta() {
		return EstatusTarjeta;
	}
	public void setEstatusTarjeta(String estatusTarjeta) {
		EstatusTarjeta = estatusTarjeta;
	}
	public String getException() {
		return Exception;
	}
	public void setException(String exception) {
		Exception = exception;
	}
}
