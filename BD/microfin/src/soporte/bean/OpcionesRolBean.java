package soporte.bean;



import java.util.List;

import general.bean.BaseBean;

public class OpcionesRolBean extends BaseBean{
	private String rolID;
	private String opcionMenuID;
	private String desplegado;
	private String recurso;
	private List menuIDCheck;
	private List listaOpcionesActual;
	
	
	//Nueva instalacion a kubo 1.1
	public List getListaOpcionesActual() {
		return listaOpcionesActual;
	}
	public void setListaOpcionesActual(List listaOpcionesActual) {
		this.listaOpcionesActual = listaOpcionesActual;
	}
	public List getMenuIDCheck() {
		return menuIDCheck;
	}
	public void setMenuIDCheck(List menuIDCheck) {
		this.menuIDCheck = menuIDCheck;
	}
	public String getRolID() {
		return rolID;
	}
	public void setRolID(String rolID) {
		this.rolID = rolID;
	}
	public String getOpcionMenuID() {
		return opcionMenuID;
	}
	public void setOpcionMenuID(String opcionMenuID) {
		this.opcionMenuID = opcionMenuID;
	}
	public String getDesplegado() {
		return desplegado;
	}
	public void setDesplegado(String desplegado) {
		this.desplegado = desplegado;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	
	
}
