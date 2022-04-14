package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class PagoCreditoRequest extends BaseBeanWS {

	private String creditoID;
	private String monto;
	private String montoGL;
	private String folio;
	private String claveUsuario;
	private String dispositivo;
	private String pagoExigible;
	private String totalAdeudo;

	public String getCreditoID() {
		return creditoID;
	}

	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}

	public String getMonto() {
		return monto;
	}

	public void setMonto(String monto) {
		this.monto = monto;
	}

	public String getMontoGL() {
		return montoGL;
	}

	public void setMontoGL(String montoGL) {
		this.montoGL = montoGL;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getClaveUsuario() {
		return claveUsuario;
	}

	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}

	public String getDispositivo() {
		return dispositivo;
	}

	public void setDispositivo(String dispositivo) {
		this.dispositivo = dispositivo;
	}

	public String getPagoExigible() {
		return pagoExigible;
	}

	public void setPagoExigible(String pagoExigible) {
		this.pagoExigible = pagoExigible;
	}

	public String getTotalAdeudo() {
		return totalAdeudo;
	}

	public void setTotalAdeudo(String totalAdeudo) {
		this.totalAdeudo = totalAdeudo;
	}

}
