package bancaMovil.bean;

import general.bean.BaseBean;

public class TiposOperacionesBean extends BaseBean {

	private String tipoOperacionID;
	private String descripcion;

	public String getTipoOperacionID() {
		return tipoOperacionID;
	}

	public void setTipoOperacionID(String tipoOperacionID) {
		this.tipoOperacionID = tipoOperacionID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

}
