package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

public class SP_PDA_Creditos_PagoResponse extends BaseBeanWS{
	private String CodigoResp;
	private String CodigoDesc;
	private String EsValido;
	private String AutFecha;
	private String FolioAut;
	private String Saldo;
	private String CapitalPagado;
	private String IntOrdPagado;
	private String IvaIntOrdPagado;
	private String IntMorPagado;
	private String IvaIntMorPagado;
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
	public String getSaldo() {
		return Saldo;
	}
	public void setSaldo(String saldo) {
		Saldo = saldo;
	}
	public String getCapitalPagado() {
		return CapitalPagado;
	}
	public void setCapitalPagado(String capitalPagado) {
		CapitalPagado = capitalPagado;
	}
	public String getIntOrdPagado() {
		return IntOrdPagado;
	}
	public void setIntOrdPagado(String intOrdPagado) {
		IntOrdPagado = intOrdPagado;
	}
	public String getIvaIntOrdPagado() {
		return IvaIntOrdPagado;
	}
	public void setIvaIntOrdPagado(String ivaIntOrdPagado) {
		IvaIntOrdPagado = ivaIntOrdPagado;
	}
	public String getIntMorPagado() {
		return IntMorPagado;
	}
	public void setIntMorPagado(String intMorPagado) {
		IntMorPagado = intMorPagado;
	}
	public String getIvaIntMorPagado() {
		return IvaIntMorPagado;
	}
	public void setIvaIntMorPagado(String ivaIntMorPagado) {
		IvaIntMorPagado = ivaIntMorPagado;
	}
}
