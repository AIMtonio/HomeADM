package soporte.bean;

import general.bean.BaseBean;

public class MenuCompletoBean extends BaseBean{

	private String menuID;
	private String desplegadoMenu;
	private String grupoID;
	private String desplegadoGrupo;
	private String opcionMenuID;
	private String desplegadoOpcion;
	private String recurso;
	private String requiereCajero;
	
	public String getMenuID() {
		return menuID;
	}
	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}
	public String getDesplegadoMenu() {
		return desplegadoMenu;
	}
	public void setDesplegadoMenu(String desplegadoMenu) {
		this.desplegadoMenu = desplegadoMenu;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getDesplegadoGrupo() {
		return desplegadoGrupo;
	}
	public void setDesplegadoGrupo(String desplegadoGrupo) {
		this.desplegadoGrupo = desplegadoGrupo;
	}
	public String getOpcionMenuID() {
		return opcionMenuID;
	}
	public void setOpcionMenuID(String opcionMenuID) {
		this.opcionMenuID = opcionMenuID;
	}
	public String getDesplegadoOpcion() {
		return desplegadoOpcion;
	}
	public void setDesplegadoOpcion(String desplegadoOpcion) {
		this.desplegadoOpcion = desplegadoOpcion;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getRequiereCajero() {
		return requiereCajero;
	}
	public void setRequiereCajero(String requiereCajero) {
		this.requiereCajero = requiereCajero;
	}
	
}
