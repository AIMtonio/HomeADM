package cuentas.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaCuentasPorClienteResponse extends BaseBeanWS{
	private String infocuenta;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
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
	public String getInfocuenta() {
		return infocuenta;
	}
	public void setInfocuenta(String infocuenta) {
		this.infocuenta = infocuenta;
	}
	
	
}
