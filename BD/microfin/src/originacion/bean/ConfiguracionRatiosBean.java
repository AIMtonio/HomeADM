package originacion.bean;

import general.bean.BaseBean;

public class ConfiguracionRatiosBean extends BaseBean {
	private String	ratiosCatalogoID;
	private String	ratiosCatalogoRelID;
	private String	descripcion;
	private String	producCreditoID;
	private String	porcentaje;
	private String	LimiteInferior;
	private String	limiteSuperior;
	private String	puntos;
	private String	tipoLista;
	private String	total;
	private String	nRegistroCat;
	
	public String getRatiosCatalogoID() {
		return ratiosCatalogoID;
	}
	
	public void setRatiosCatalogoID(String ratiosCatalogoID) {
		this.ratiosCatalogoID = ratiosCatalogoID;
	}
	
	public String getRatiosCatalogoRelID() {
		return ratiosCatalogoRelID;
	}
	
	public void setRatiosCatalogoRelID(String ratiosCatalogoRelID) {
		this.ratiosCatalogoRelID = ratiosCatalogoRelID;
	}
	
	public String getDescripcion() {
		return descripcion;
	}
	
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public String getProducCreditoID() {
		return producCreditoID;
	}
	
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	
	public String getPorcentaje() {
		return porcentaje;
	}
	
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	
	public String getLimiteInferior() {
		return LimiteInferior;
	}
	
	public void setLimiteInferior(String limiteInferior) {
		LimiteInferior = limiteInferior;
	}
	
	public String getLimiteSuperior() {
		return limiteSuperior;
	}
	
	public void setLimiteSuperior(String limiteSuperior) {
		this.limiteSuperior = limiteSuperior;
	}
	
	public String getPuntos() {
		return puntos;
	}
	
	public void setPuntos(String puntos) {
		this.puntos = puntos;
	}
	
	public String getTipoLista() {
		return tipoLista;
	}
	
	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}
	
	public String getTotal() {
		return total;
	}
	
	public void setTotal(String total) {
		this.total = total;
	}
	
	public String getnRegistroCat() {
		return nRegistroCat;
	}
	
	public void setnRegistroCat(String nRegistroCat) {
		this.nRegistroCat = nRegistroCat;
	}
	
}
