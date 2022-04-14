package credito.bean;

import general.bean.BaseBean;

public class RepPlanPagosGrupalBean extends BaseBean{
	private String promotorActual;
	private String sucursal;
	private String grupoID;
	private String fechaMinistrado;
	private String montoCredito;
	private String nombreProducto;
	private String nombreInstitucion;
	

	public String getPromotorActual() {
		return promotorActual;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public String getFechaMinistrado() {
		return fechaMinistrado;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setPromotorActual(String promotorActual) {
		this.promotorActual = promotorActual;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public void setFechaMinistrado(String fechaMinistrado) {
		this.fechaMinistrado = fechaMinistrado;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	
}
