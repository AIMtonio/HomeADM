package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

public class SP_PDA_Ahorros_Retiro3ReyesResponse extends BaseBeanWS{
	private String CodigoResp;
	private String CodigoDesc;
	private String EsValido;
	private String AutFecha;
	private String FolioAut;
	private String SaldoTot;
	private String SaldoDisp;
	
	public String getCodigoResp() {
		return CodigoResp;
	}
	public void setCodigoResp(String codigoResp) {
		CodigoResp = codigoResp;
	}
	public String getCodigoDesc() {
		return CodigoDesc;
	}
	public void setCodigoDesc(String codigoDesc) {
		CodigoDesc = codigoDesc;
	}
	public String getEsValido() {
		return EsValido;
	}
	public void setEsValido(String esValido) {
		EsValido = esValido;
	}
	public String getAutFecha() {
		return AutFecha;
	}
	public void setAutFecha(String autFecha) {
		AutFecha = autFecha;
	}
	public String getFolioAut() {
		return FolioAut;
	}
	public void setFolioAut(String folioAut) {
		FolioAut = folioAut;
	}
	public String getSaldoTot() {
		return SaldoTot;
	}
	public void setSaldoTot(String saldoTot) {
		SaldoTot = saldoTot;
	}
	public String getSaldoDisp() {
		return SaldoDisp;
	}
	public void setSaldoDisp(String saldoDisp) {
		SaldoDisp = saldoDisp;
	}
	
}
