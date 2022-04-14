package cuentas.bean;

import general.bean.BaseBean;

public class AltaPreguntasSeguridadBean extends BaseBean{
	
	private String preguntaID;
	private String descripcion;

	public String getPreguntaID() {
		return preguntaID;
	}
	public void setPreguntaID(String preguntaID) {
		this.preguntaID = preguntaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
