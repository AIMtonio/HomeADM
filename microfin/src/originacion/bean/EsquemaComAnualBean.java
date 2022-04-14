package originacion.bean;

import general.bean.BaseBean;

public class EsquemaComAnualBean extends BaseBean {
	private String	producCreditoID;
	private String	cobraComision;
	private String	tipoComision;
	private String	baseCalculo;
	private String	montoComision;
	private String	porcentajeComision;
	private String	diasGracia;
	
	public String getProducCreditoID() {
		return producCreditoID;
	}
	
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	
	public String getCobraComision() {
		return cobraComision;
	}
	
	public void setCobraComision(String cobraComision) {
		this.cobraComision = cobraComision;
	}
	
	public String getTipoComision() {
		return tipoComision;
	}
	
	public void setTipoComision(String tipoComision) {
		this.tipoComision = tipoComision;
	}
	
	public String getBaseCalculo() {
		return baseCalculo;
	}
	
	public void setBaseCalculo(String baseCalculo) {
		this.baseCalculo = baseCalculo;
	}
	
	public String getMontoComision() {
		return montoComision;
	}
	
	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	
	public String getPorcentajeComision() {
		return porcentajeComision;
	}
	
	public void setPorcentajeComision(String porcentajeComision) {
		this.porcentajeComision = porcentajeComision;
	}
	
	public String getDiasGracia() {
		return diasGracia;
	}
	
	public void setDiasGracia(String diasGracia) {
		this.diasGracia = diasGracia;
	}
	
}
