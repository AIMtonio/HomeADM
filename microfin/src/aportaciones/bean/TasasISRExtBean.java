package aportaciones.bean;

import java.util.List;

public class TasasISRExtBean {

	private String paisID;
	private String nombre;
	private String tasaISR;
	private String detalle;
	private List listaPaises;

	public String getPaisID() {
		return paisID;
	}

	public void setPaisID(String paisID) {
		this.paisID = paisID;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getTasaISR() {
		return tasaISR;
	}

	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}

	public String getDetalle() {
		return detalle;
	}

	public void setDetalle(String detalle) {
		this.detalle = detalle;
	}

	public List getListaPaises() {
		return listaPaises;
	}

	public void setListaPaises(List listaPaises) {
		this.listaPaises = listaPaises;
	}

}