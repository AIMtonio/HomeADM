package operacionesPDM.beanWS.response;

public class SP_PDM_Ahorros_AbonoCtaResponse {
	
	private int CodigoResp;
	private String CodigoDesc;
	private String EsValido;
	private String AutFecha;
	private String FolioAut;
	private String SaldoTot;
	private String SaldoDisp;
	
	public int getCodigoResp() {
		return CodigoResp;
	}
	public void setCodigoResp(int codigoResp) {
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
