package credito.bean;

import general.bean.BaseBean;

public class EsquemaComisionCreBean extends BaseBean{
	
	//Declaracion de Variables o Atributos
	
	private String esquemaComID;
	private String montoInicial;
	private String montoFinal;
	private String tipoComision;
	private String comision;
	private	String producCreditoID;
	
	//Variables Auxiliares del Bean
	private String criterioComFalPag;
	private String montoMinComFalPag;
	
	private String perCobComFalPag;
	private String tipCobComFalPago;
	private String prorrateoComFalPag;
	
	private String tipoPagoComFalPago;
	
	public String getMontoInicial() {
		return montoInicial;
	}
	public void setMontoInicial(String montoInicial) {
		this.montoInicial = montoInicial;
	}
	public String getMontoFinal() {
		return montoFinal;
	}
	public void setMontoFinal(String montoFinal) {
		this.montoFinal = montoFinal;
	}
	public String getTipoComision() {
		return tipoComision;
	}
	public void setTipoComision(String tipoComision) {
		this.tipoComision = tipoComision;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getEsquemaComID() {
		return esquemaComID;
	}
	public void setEsquemaComID(String esquemaComID) {
		this.esquemaComID = esquemaComID;
	}
	public String getCriterioComFalPag() {
		return criterioComFalPag;
	}
	public void setCriterioComFalPag(String criterioComFalPag) {
		this.criterioComFalPag = criterioComFalPag;
	}
	public String getMontoMinComFalPag() {
		return montoMinComFalPag;
	}
	public void setMontoMinComFalPag(String montoMinComFalPag) {
		this.montoMinComFalPag = montoMinComFalPag;
	}
	public String getPerCobComFalPag() {
		return perCobComFalPag;
	}
	public void setPerCobComFalPag(String perCobComFalPag) {
		this.perCobComFalPag = perCobComFalPag;
	}
	public String getTipCobComFalPago() {
		return tipCobComFalPago;
	}
	public void setTipCobComFalPago(String tipCobComFalPago) {
		this.tipCobComFalPago = tipCobComFalPago;
	}
	public String getProrrateoComFalPag() {
		return prorrateoComFalPag;
	}
	public void setProrrateoComFalPag(String prorrateoComFalPag) {
		this.prorrateoComFalPag = prorrateoComFalPag;
	}
	public String getTipoPagoComFalPago() {
		return tipoPagoComFalPago;
	}
	public void setTipoPagoComFalPago(String tipoPagoComFalPago) {
		this.tipoPagoComFalPago = tipoPagoComFalPago;
	}
	
	
}
