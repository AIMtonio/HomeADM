package guardaValores.bean;

import general.bean.BaseBean;

public class CatalogoAlmacenesBean extends BaseBean {

	private String almacenID;
	private String nombreAlmacen;
	private String estatus;
	private String sucursalID;

	public String getAlmacenID() {
		return almacenID;
	}
	public void setAlmacenID(String almacenID) {
		this.almacenID = almacenID;
	}
	public String getNombreAlmacen() {
		return nombreAlmacen;
	}
	public void setNombreAlmacen(String nombreAlmacen) {
		this.nombreAlmacen = nombreAlmacen;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

}
