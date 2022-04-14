package soporte.bean;

import general.bean.BaseBean;

public class FoliosAplicaBean extends BaseBean {	
	private String folio;
	private String tabla;
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getTabla() {
		return tabla;
	}
	public void setTabla(String tabla) {
		this.tabla = tabla;
	}
}