package originacion.bean;

import java.util.List;

import general.bean.BaseBean;

public class DiasPasoVencidoBean extends BaseBean {
	private String producCreditoID;
	private String frecuencia;
	private String diasPasoVencido;
	
	 private 	List lfrecuencia;
	 private 	List ldiasPasoVencido;
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getDiasPasoVencido() {
		return diasPasoVencido;
	}
	public void setDiasPasoVencido(String diasPasoVencido) {
		this.diasPasoVencido = diasPasoVencido;
	}
	public List getLfrecuencia() {
		return lfrecuencia;
	}
	public void setLfrecuencia(List lfrecuencia) {
		this.lfrecuencia = lfrecuencia;
	}
	public List getLdiasPasoVencido() {
		return ldiasPasoVencido;
	}
	public void setLdiasPasoVencido(List ldiasPasoVencido) {
		this.ldiasPasoVencido = ldiasPasoVencido;
	}
	
	

}
