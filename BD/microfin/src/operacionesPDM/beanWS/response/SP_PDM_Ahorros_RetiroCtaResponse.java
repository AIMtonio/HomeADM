package operacionesPDM.beanWS.response;

public class SP_PDM_Ahorros_RetiroCtaResponse {
	
	private int codigoResp;
	private String codigoDesc;
	private String esValido;
	private String autFecha;
	private String folioAut;
	private String saldoTot;
	private String saldoDisp;
	
	public int getCodigoResp() {
		return codigoResp;
	}
	public void setCodigoResp(int codigoResp) {
		this.codigoResp = codigoResp;
	}
	public String getCodigoDesc() {
		return codigoDesc;
	}
	public void setCodigoDesc(String codigoDesc) {
		this.codigoDesc = codigoDesc;
	}
	public String getEsValido() {
		return esValido;
	}
	public void setEsValido(String esValido) {
		this.esValido = esValido;
	}
	public String getAutFecha() {
		return autFecha;
	}
	public void setAutFecha(String autFecha) {
		this.autFecha = autFecha;
	}
	public String getFolioAut() {
		return folioAut;
	}
	public void setFolioAut(String folioAut) {
		this.folioAut = folioAut;
	}
	public String getSaldoTot() {
		return saldoTot;
	}
	public void setSaldoTot(String saldoTot) {
		this.saldoTot = saldoTot;
	}
	public String getSaldoDisp() {
		return saldoDisp;
	}
	public void setSaldoDisp(String saldoDisp) {
		this.saldoDisp = saldoDisp;
	}
	

}
