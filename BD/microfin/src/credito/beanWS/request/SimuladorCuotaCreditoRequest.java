package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class SimuladorCuotaCreditoRequest  extends BaseBeanWS{
	private String montoSolici;
	private String frecuencia;
	private String plazo;
	private String tasaAnualizada;
	private String fechaInicio;
	private String ajustarFecVen;
	private String comisionApertura;
	private String formaCobroComAp;
	public String getMontoSolici() {
		return montoSolici;
	}
	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getTasaAnualizada() {
		return tasaAnualizada;
	}
	public void setTasaAnualizada(String tasaAnualizada) {
		this.tasaAnualizada = tasaAnualizada;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getAjustarFecVen() {
		return ajustarFecVen;
	}
	public void setAjustarFecVen(String ajustarFecVen) {
		this.ajustarFecVen = ajustarFecVen;
	}
	public String getComisionApertura() {
		return comisionApertura;
	}
	public void setComisionApertura(String comisionApertura) {
		this.comisionApertura = comisionApertura;
	}
	public String getFormaCobroComAp() {
		return formaCobroComAp;
	}
	public void setFormaCobroComAp(String formaCobroComAp) {
		this.formaCobroComAp = formaCobroComAp;
	}

}