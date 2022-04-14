package spei.bean;

import general.bean.BaseBean;

public class OrigenesSpeiBean extends BaseBean {

	private String origenSpeiID;
	private String nombreCompleto;
	private String orden;

	public String getOrigenSpeiID() {
		return origenSpeiID;
	}

	public void setOrigenSpeiID(String origenSpeiID) {
		this.origenSpeiID = origenSpeiID;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getOrden() {
		return orden;
	}

	public void setOrden(String orden) {
		this.orden = orden;
	}

}