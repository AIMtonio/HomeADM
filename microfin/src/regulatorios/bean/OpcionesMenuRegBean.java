package regulatorios.bean;

import general.bean.BaseBean;

public class OpcionesMenuRegBean extends BaseBean {
	private String opcionMenuID;
	private String menuID;
	private String codigoOpcion; 	 
	private String descripcion;
	private String plazo;
	private String tipoInstitID;
	private String organoID;
	
	public String getOpcionMenuID() {
		return opcionMenuID;
	}
	public void setOpcionMenuID(String opcionMenuID) {
		this.opcionMenuID = opcionMenuID;
	}
	public String getMenuID() {
		return menuID;
	}
	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}
	public String getCodigoOpcion() {
		return codigoOpcion;
	}
	public void setCodigoOpcion(String codigoOpcion) {
		this.codigoOpcion = codigoOpcion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getTipoInstitID() {
		return tipoInstitID;
	}
	public void setTipoInstitID(String tipoInstitID) {
		this.tipoInstitID = tipoInstitID;
	}
	public String getOrganoID() {
		return organoID;
	}
	public void setOrganoID(String organoID) {
		this.organoID = organoID;
	}
	

	

}
