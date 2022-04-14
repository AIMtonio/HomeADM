package soporte.bean;

import java.util.Date;

import general.bean.BaseBean;


public class OperacionesFechasBean extends BaseBean {

	private String 	primerFecha; 
	private String 	segundaFecha;
	private int 	numeroDias;
	private String	fechaCalculada;
	private String	fechaHabil;
	private String	esDiaHabil;
	private String 	fechaResultado;
	private int 	diasEntreFechas;
	private String 	diaInhabil;
	private String  diaPago;
	
	public String getPrimerFecha() {
		return primerFecha;
	}
	public void setPrimerFecha(String primerFecha) {
		this.primerFecha = primerFecha;
	}
	public String getSegundaFecha() {
		return segundaFecha;
	}
	public void setSegundaFecha(String segundaFecha) {
		this.segundaFecha = segundaFecha;
	}
	public int getNumeroDias() {
		return numeroDias;
	}
	public void setNumeroDias(int numeroDias) {
		this.numeroDias = numeroDias;
	}
	public String getFechaCalculada() {
		return fechaCalculada;
	}
	public void setFechaCalculada(String fechaCalculada) {
		this.fechaCalculada = fechaCalculada;
	}
	public String getFechaHabil() {
		return fechaHabil;
	}
	public void setFechaHabil(String fechaHabil) {
		this.fechaHabil = fechaHabil;
	}
	public String getEsDiaHabil() {
		return esDiaHabil;
	}
	public void setEsDiaHabil(String esDiaHabil) {
		this.esDiaHabil = esDiaHabil;
	}
	public String getFechaResultado() {
		return fechaResultado;
	}
	public void setFechaResultado(String fechaResultado) {
		this.fechaResultado = fechaResultado;
	}
	public int getDiasEntreFechas() {
		return diasEntreFechas;
	}
	public void setDiasEntreFechas(int diasEntreFechas) {
		this.diasEntreFechas = diasEntreFechas;
	}
	public String getDiaInhabil() {
		return diaInhabil;
	}
	public void setDiaInhabil(String diaInhabil) {
		this.diaInhabil = diaInhabil;
	}
	public String getDiaPago() {
		return diaPago;
	}
	public void setDiaPago(String diaPago) {
		this.diaPago = diaPago;
	}
		
}
