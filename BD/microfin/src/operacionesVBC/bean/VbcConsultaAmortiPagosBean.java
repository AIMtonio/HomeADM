package operacionesVBC.bean;

import general.bean.BaseBean;

public class VbcConsultaAmortiPagosBean extends BaseBean {
	
	//Atributos o Variables
	private String creditoID;
	private String amortizacionID;
	private String clienteID;
	private String fechaExigible;	
	private String totalPagado;
	
	private String capitalPagado;
	private String interes;
	private String ivaInteres;
	private String interesMora;
	private String ivaInteresMora;
	
	private String fechaPago;
	private String diasAtraso;
	private String estatus;

	private String codigoError;
	private String mensajeError;
	private String numTransaccion;
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
	public String getTotalPagado() {
		return totalPagado;
	}
	public void setTotalPagado(String totalPagado) {
		this.totalPagado = totalPagado;
	}
	public String getCapitalPagado() {
		return capitalPagado;
	}
	public void setCapitalPagado(String capitalPagado) {
		this.capitalPagado = capitalPagado;
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
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
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
	