package regulatorios.bean;

import general.bean.BaseBean;

public class ClaveRelacionCNVBBean extends BaseBean {
	private String claveRelacionID;
	private String descripcion;
	
	public String getClaveRelacionID() {
		return claveRelacionID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setClaveRelacionID(String claveRelacionID) {
		this.claveRelacionID = claveRelacionID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
