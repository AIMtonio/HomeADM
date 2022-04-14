package credito.bean;

import general.bean.BaseBean;

public class ParamsReservCastigBean extends BaseBean   {  
	 private String empresaID;        
	 private String regContaEPRC;       
	 private String ePRCIntMorato;        
	 private String divideEPRCCapitaInteres;               
	 private String condonaIntereCarVen;            
	 private String condonaMoratoCarVen;           
	 private String condonaAccesorios;
	 private String eprcAdicional;
	 private String divideCastigo;
	 private String IVARecuperacion;
	 
	 
	public String getIVARecuperacion() {
		return IVARecuperacion;
	}
	public void setIVARecuperacion(String iVARecuperacion) {
		IVARecuperacion = iVARecuperacion;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getRegContaEPRC() {
		return regContaEPRC;
	}
	public void setRegContaEPRC(String regContaEPRC) {
		this.regContaEPRC = regContaEPRC;
	}
	public String getePRCIntMorato() {
		return ePRCIntMorato;
	}
	public void setePRCIntMorato(String ePRCIntMorato) {
		this.ePRCIntMorato = ePRCIntMorato;
	}
	public String getDivideEPRCCapitaInteres() {
		return divideEPRCCapitaInteres;
	}
	public void setDivideEPRCCapitaInteres(String divideEPRCCapitaInteres) {
		this.divideEPRCCapitaInteres = divideEPRCCapitaInteres;
	}
	public String getCondonaIntereCarVen() {
		return condonaIntereCarVen;
	}
	public void setCondonaIntereCarVen(String condonaIntereCarVen) {
		this.condonaIntereCarVen = condonaIntereCarVen;
	}
	public String getCondonaMoratoCarVen() {
		return condonaMoratoCarVen;
	}
	public void setCondonaMoratoCarVen(String condonaMoratoCarVen) {
		this.condonaMoratoCarVen = condonaMoratoCarVen;
	}
	public String getCondonaAccesorios() {
		return condonaAccesorios;
	}
	public void setCondonaAccesorios(String condonaAccesorios) {
		this.condonaAccesorios = condonaAccesorios;
	}
	public String getDivideCastigo() {
		return divideCastigo;
	}
	public void setDivideCastigo(String divideCastigo) {
		this.divideCastigo = divideCastigo;
	}
	public String getEprcAdicional() {
		return eprcAdicional;
	}
	public void setEprcAdicional(String eprcAdicional) {
		this.eprcAdicional = eprcAdicional;
	}    
	 
	 
		

}
