package ventanilla.bean;

import general.bean.BaseBean;

public class CatalogoRemesasBean extends BaseBean {
	
	private String remesaCatalogoID;
	private String nombre;
	private String nombreCorto;
	private String cuentaCompleta;
	private String cCostosRemesa;
	
	private String estatus;
	
	public String getRemesaCatalogoID() {
		return remesaCatalogoID;
	}
	public void setRemesaCatalogoID(String remesaCatalogoID) {
		this.remesaCatalogoID = remesaCatalogoID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNombreCorto() {
		return nombreCorto;
	}
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
	public String getCuentaCompleta() {
		return cuentaCompleta;
	}
	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}
	public String getcCostosRemesa() {
		return cCostosRemesa;
	}
	public void setcCostosRemesa(String cCostosRemesa) {
		this.cCostosRemesa = cCostosRemesa;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
}
