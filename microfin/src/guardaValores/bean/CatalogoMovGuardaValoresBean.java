package guardaValores.bean;

import general.bean.BaseBean;

public class CatalogoMovGuardaValoresBean extends BaseBean{
	private String catMovimientoID;
	private String nombreMovimiento;
	private String descripcion;
	private String estatus;
	
	public String getCatMovimientoID() {
		return catMovimientoID;
	}
	public void setCatMovimientoID(String catMovimientoID) {
		this.catMovimientoID = catMovimientoID;
	}
	public String getNombreMovimiento() {
		return nombreMovimiento;
	}
	public void setNombreMovimiento(String nombreMovimiento) {
		this.nombreMovimiento = nombreMovimiento;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
}
