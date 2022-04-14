package seguimiento.bean;

import general.bean.BaseBean;

public class ResultadoSegtoCobranzaBean extends BaseBean{
	
	
	private String segtoPrograID;

	private String segtoRealizaID;
	private String fechaPromPago;
	private String montoPromPago;
	private String existFlujo;
	private String fechaEstFlujo;
	private String origenPagoID;
	private String motivoNPID;
	private String nomOriRecursos;
	private String telefonFijo;
	private String telefonCel;
	
	//getter and setter
	public String getSegtoPrograID() {
		return segtoPrograID;
	}
	public void setSegtoPrograID(String segtoPrograID) {
		this.segtoPrograID = segtoPrograID;
	}
	public String getSegtoRealizaID() {
		return segtoRealizaID;
	}
	public void setSegtoRealizaID(String segtoRealizaID) {
		this.segtoRealizaID = segtoRealizaID;
	}
	public String getFechaPromPago() {
		return fechaPromPago;
	}
	public void setFechaPromPago(String fechaPromPago) {
		this.fechaPromPago = fechaPromPago;
	}
	public String getMontoPromPago() {
		return montoPromPago;
	}
	public void setMontoPromPago(String montoPromPago) {
		this.montoPromPago = montoPromPago;
	}
	public String getExistFlujo() {
		return existFlujo;
	}
	public void setExistFlujo(String existFlujo) {
		this.existFlujo = existFlujo;
	}
	public String getFechaEstFlujo() {
		return fechaEstFlujo;
	}
	public void setFechaEstFlujo(String fechaEstFlujo) {
		this.fechaEstFlujo = fechaEstFlujo;
	}

	public String getOrigenPagoID() {
		return origenPagoID;
	}
	public void setOrigenPagoID(String origenPagoID) {
		this.origenPagoID = origenPagoID;
	}
	public String getMotivoNPID() {
		return motivoNPID;
	}
	public void setMotivoNPID(String motivoNPID) {
		this.motivoNPID = motivoNPID;
	}
	
	public String getTelefonCel() {
		return telefonCel;
	}
	public void setTelefonCel(String telefonCel) {
		this.telefonCel = telefonCel;
	}

	public String getNomOriRecursos() {
		return nomOriRecursos;
	}
	public void setNomOriRecursos(String nomOriRecursos) {
		this.nomOriRecursos = nomOriRecursos;
	}
	public String getTelefonFijo() {
		return telefonFijo;
	}
	public void setTelefonFijo(String telefonFijo) {
		this.telefonFijo = telefonFijo;
	}
}
