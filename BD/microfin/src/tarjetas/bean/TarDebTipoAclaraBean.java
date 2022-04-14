package tarjetas.bean;

import general.bean.BaseBean;

public class TarDebTipoAclaraBean extends BaseBean {
	// Declaracion de Constantes

	private String tipoAclaracionID;
	private String descripcion;

	public String getTipoAclaracionID() {
		return tipoAclaracionID;
	}

	public void setTipoAclaracionID(String tipoAclaracionID) {
		this.tipoAclaracionID = tipoAclaracionID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
