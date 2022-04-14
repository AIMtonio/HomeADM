package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaCreditoBEResponse extends BaseBeanWS{
	
	private String creditoID;
	
	private String cuentaID;
	private String estatus;
	private String productoCreditoID;
	private String descripcionCredito;
	private String tipoMoneda;
	private String valorCat;
	private String tasaFija;
	private String diasFaltaPago;
	private String totalDeuda;
	private String montoExigible;
	private String proxFechaPag;
	private String saldoCapVigente;
	private String saldoCapAtrasa;
	private String saldoInteresesAtr;
	private String saldoInteresVig;
	private String saldoIVAIntVig;
	private String saldoMoratorios;

	
	private String saldoIVAAtrasa;
	private String saldoComFaltaPago;
	private String saldoOtrasComis;
	private String saldoIVAMorato;
	private String saldoIVAComFaltaPago;
	private String saldoIVAComisi;
		
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	
	public String getCuentaID() {
		return cuentaID;
	}
	public String getSaldoIVAAtrasa() {
		return saldoIVAAtrasa;
	}
	public void setSaldoIVAAtrasa(String saldoIVAAtrasa) {
		this.saldoIVAAtrasa = saldoIVAAtrasa;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getDescripcionCredito() {
		return descripcionCredito;
	}
	public void setDescripcionCredito(String descripcionCredito) {
		this.descripcionCredito = descripcionCredito;
	}
	public String getTipoMoneda() {
		return tipoMoneda;
	}
	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}
	public String getValorCat() {
		return valorCat;
	}
	public void setValorCat(String valorCat) {
		this.valorCat = valorCat;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getDiasFaltaPago() {
		return diasFaltaPago;
	}
	public void setDiasFaltaPago(String diasFaltaPago) {
		this.diasFaltaPago = diasFaltaPago;
	}
	public String getTotalDeauda() {
		return totalDeuda;
	}
	public void setTotalDeauda(String totalDeauda) {
		this.totalDeuda = totalDeauda;
	}
	public String getMontoExigible() {
		return montoExigible;
	}
	public void setMontoExigible(String montoExigible) {
		this.montoExigible = montoExigible;
	}
	public String getProxFechaPag() {
		return proxFechaPag;
	}
	public void setProxFechaPag(String proxFechaPag) {
		this.proxFechaPag = proxFechaPag;
	}
	public String getSaldoCapVigente() {
		return saldoCapVigente;
	}
	public void setSaldoCapVigente(String saldoCapVigente) {
		this.saldoCapVigente = saldoCapVigente;
	}
	public String getSaldoCapAtrasa() {
		return saldoCapAtrasa;
	}
	public void setSaldoCapAtrasa(String saldoCapAtrasa) {
		this.saldoCapAtrasa = saldoCapAtrasa;
	}
	public String getSaldoInteresesAtr() {
		return saldoInteresesAtr;
	}
	public void setSaldoInteresesAtr(String saldoInteresesAtr) {
		this.saldoInteresesAtr = saldoInteresesAtr;
	}
	public String getSaldoInteresVig() {
		return saldoInteresVig;
	}
	public void setSaldoInteresVig(String saldoInteresVig) {
		this.saldoInteresVig = saldoInteresVig;
	}
	public String getSaldoIVAIntVig() {
		return saldoIVAIntVig;
	}
	public void setSaldoIVAIntVig(String saldoIVAIntVig) {
		this.saldoIVAIntVig = saldoIVAIntVig;
	}
	
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}

	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getTotalDeuda() {
		return totalDeuda;
	}
	public void setTotalDeuda(String totalDeuda) {
		this.totalDeuda = totalDeuda;
	}
	
	public String getSaldoComFaltaPago() {
		return saldoComFaltaPago;
	}
	public void setSaldoComFaltaPago(String saldoComFaltaPago) {
		this.saldoComFaltaPago = saldoComFaltaPago;
	}
	public String getSaldoOtrasComis() {
		return saldoOtrasComis;
	}
	public void setSaldoOtrasComis(String saldoOtrasComis) {
		this.saldoOtrasComis = saldoOtrasComis;
	}
	public String getSaldoIVAMorato() {
		return saldoIVAMorato;
	}
	public void setSaldoIVAMorato(String saldoIVAMorato) {
		this.saldoIVAMorato = saldoIVAMorato;
	}
	public String getSaldoIVAComFaltaPago() {
		return saldoIVAComFaltaPago;
	}
	public void setSaldoIVAComFaltaPago(String saldoIVAComFaltaPago) {
		this.saldoIVAComFaltaPago = saldoIVAComFaltaPago;
	}
	public String getSaldoIVAComisi() {
		return saldoIVAComisi;
	}
	public void setSaldoIVAComisi(String saldoIVAComisi) {
		this.saldoIVAComisi = saldoIVAComisi;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	
	
	
	
}
