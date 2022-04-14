package soporte.bean;

import general.bean.BaseBean;

import java.util.HashMap;
import java.util.List;

public class MenuAplicacionBean extends BaseBean {
	
	private List menus; 
	private HashMap gruposMenu;
	private HashMap opcionesMenu;
	
	public List getMenus() {
		return menus;
	}
	public void setMenus(List menus) {
		this.menus = menus;
	}
	public HashMap getGruposMenu() {
		return gruposMenu;
	}
	public void setGruposMenu(HashMap gruposMenu) {
		this.gruposMenu = gruposMenu;
	}
	public HashMap getOpcionesMenu() {
		return opcionesMenu;
	}
	public void setOpcionesMenu(HashMap opcionesMenu) {
		this.opcionesMenu = opcionesMenu;
	}
	
	
	
}
