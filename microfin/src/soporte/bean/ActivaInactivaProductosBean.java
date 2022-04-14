package soporte.bean;

import general.bean.BaseBean;

public class ActivaInactivaProductosBean extends BaseBean{
	public String tipoProducto;
	public String numProducto;
	public String nombre;
	public String nombreCorto;
	public String estatus;
	
	public String getTipoProducto() {
		return tipoProducto;
	}
	public void setTipoProducto(String tipoProducto) {
		this.tipoProducto = tipoProducto;
	}
	public String getNumProducto() {
		return numProducto;
	}
	public void setNumProducto(String numProducto) {
		this.numProducto = numProducto;
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
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

}
