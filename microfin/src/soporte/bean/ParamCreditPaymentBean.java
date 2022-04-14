package soporte.bean;

import general.bean.BaseBean;

public class ParamCreditPaymentBean extends BaseBean {
	
	private String paramCreditPaymentID;
	private String producCreditoID;		
	private String pagoCredAutom;		
	private String exigible;			
	private String sobrante;		
	private String aplicaCobranzaRef;	
	
	public String getParamCreditPaymentID() {
		return paramCreditPaymentID;
	}
	public void setParamCreditPaymentID(String paramCreditPaymentID) {
		this.paramCreditPaymentID = paramCreditPaymentID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getPagoCredAutom() {
		return pagoCredAutom;
	}
	public void setPagoCredAutom(String pagoCredAutom) {
		this.pagoCredAutom = pagoCredAutom;
	}
	public String getExigible() {
		return exigible;
	}
	public void setExigible(String exigible) {
		this.exigible = exigible;
	}
	public String getSobrante() {
		return sobrante;
	}
	public void setSobrante(String sobrante) {
		this.sobrante = sobrante;
	}
	public String getAplicaCobranzaRef() {
		return aplicaCobranzaRef;
	}
	public void setAplicaCobranzaRef(String aplicaCobranzaRef) {
		this.aplicaCobranzaRef = aplicaCobranzaRef;
	}
	
}