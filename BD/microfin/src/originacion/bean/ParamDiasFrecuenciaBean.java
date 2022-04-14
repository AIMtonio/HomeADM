package originacion.bean;

import general.bean.BaseBean;

public class ParamDiasFrecuenciaBean extends BaseBean {
	private String producCreditoID;
	private String frecuencia;
	private String dias;
	private String diaInicio;
	private String diaFinal;
	private String cobro;
	private String diaCobro;
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
	public String getDias() {
		return dias;
	}
	public void setDias(String dias) {
		this.dias = dias;
	}
	public String getDiaInicio() {
		return diaInicio;
	}
	public void setDiaInicio(String diaInicio) {
		this.diaInicio = diaInicio;
	}
	public String getDiaFinal() {
		return diaFinal;
	}
	public void setDiaFinal(String diaFinal) {
		this.diaFinal = diaFinal;
	}
	public String getCobro() {
		return cobro;
	}
	public void setCobro(String cobro) {
		this.cobro = cobro;
	}
	public String getDiaCobro() {
		return diaCobro;
	}
	public void setDiaCobro(String diaCobro) {
		this.diaCobro = diaCobro;
	}

}
