package arrendamiento.bean;

import general.bean.BaseBean;

public class ProductoArrendaBean extends BaseBean{
	private String productoArrendaID;
	private String nombreCorto;
	private String descripcion;
	public String getProductoArrendaID() {
		return productoArrendaID;
	}
	public void setProductoArrendaID(String productoArrendaID) {
		this.productoArrendaID = productoArrendaID;
	}
	public String getNombreCorto() {
		return nombreCorto;
	}
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
}
