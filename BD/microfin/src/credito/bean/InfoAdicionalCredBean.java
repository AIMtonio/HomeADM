package credito.bean;

import general.bean.BaseBean;

public class InfoAdicionalCredBean extends BaseBean{
	private String creditoID;
	private String placa;
	private String gnv;
	private String vin;
	private String estatusWS;
	
	//Adicionales
	private String nombreCom;
	
	//WS
	private String llaveParametro;
	private String valorParametro;
	private String timeOutConWS;
	private String usuarioWSNG;
	private String passwordWSNG;
	private String urlWSNG;
	private double recaudo;
	private double plazo;
	
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getPlaca() {
		return placa;
	}
	public void setPlaca(String placa) {
		this.placa = placa;
	}
	public String getGnv() {
		return gnv;
	}
	public void setGnv(String gnv) {
		this.gnv = gnv;
	}
	public String getVin() {
		return vin;
	}
	public void setVin(String vin) {
		this.vin = vin;
	}
	public String getEstatusWS() {
		return estatusWS;
	}
	public void setEstatusWS(String estatusWS) {
		this.estatusWS = estatusWS;
	}
	public String getNombreCom() {
		return nombreCom;
	}
	public void setNombreCom(String nombreCom) {
		this.nombreCom = nombreCom;
	}
	public String getLlaveParametro() {
		return llaveParametro;
	}
	public void setLlaveParametro(String llaveParametro) {
		this.llaveParametro = llaveParametro;
	}
	public String getValorParametro() {
		return valorParametro;
	}
	public void setValorParametro(String valorParametro) {
		this.valorParametro = valorParametro;
	}
	public String getTimeOutConWS() {
		return timeOutConWS;
	}
	public void setTimeOutConWS(String timeOutConWS) {
		this.timeOutConWS = timeOutConWS;
	}
	public String getUsuarioWSNG() {
		return usuarioWSNG;
	}
	public void setUsuarioWSNG(String usuarioWSNG) {
		this.usuarioWSNG = usuarioWSNG;
	}
	public String getPasswordWSNG() {
		return passwordWSNG;
	}
	public void setPasswordWSNG(String passwordWSNG) {
		this.passwordWSNG = passwordWSNG;
	}
	public String getUrlWSNG() {
		return urlWSNG;
	}
	public void setUrlWSNG(String urlWSNG) {
		this.urlWSNG = urlWSNG;
	}
	public double getRecaudo() {
		return recaudo;
	}
	public void setRecaudo(double recaudo) {
		this.recaudo = recaudo;
	}
	public double getPlazo() {
		return plazo;
	}
	public void setPlazo(double plazo) {
		this.plazo = plazo;
	}
}