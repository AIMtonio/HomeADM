package operacionesVBC.bean;

import general.bean.BaseBean;

public class VbcConsultaAmortizacionesBean extends BaseBean {
	
	//Atributos o Variables
	private String creditoID;
	private String amortizacionID;
	private String clienteID;
	private String fechaExigible;	
	private String totalExigible;
	
	private String capital;
	private String interes;
	private String ivaInteres;
	private String interesMora;
	private String ivaInteresMora;
	private String estatus;

	private String codigoError;
	private String mensajeError;
	private String numTransaccion;
	
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getFechaExigible() {
		return fechaExigible;
	}
	public void setFechaExigible(String fechaExigible) {
		this.fechaExigible = fechaExigible;
	}
	public String getTotalExigible() {
		return totalExigible;
	}
	public void setTotalExigible(String totalExigible) {
		this.totalExigible = totalExigible;
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
	public String getIvaInteres() {
		return ivaInteres;
	}
	public void setIvaInteres(String ivaInteres) {
		this.ivaInteres = ivaInteres;
	}
	public String getInteresMora() {
		return interesMora;
	}
	public void setInteresMora(String interesMora) {
		this.interesMora = interesMora;
	}
	public String getIvaInteresMora() {
		return ivaInteresMora;
	}
	public void setIvaInteresMora(String ivaInteresMora) {
		this.ivaInteresMora = ivaInteresMora;
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
}
	