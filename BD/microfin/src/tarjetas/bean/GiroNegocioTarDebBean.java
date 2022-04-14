
package tarjetas.bean;

import general.bean.BaseBean;
public class GiroNegocioTarDebBean extends BaseBean{
	
	private String giroID;
	private String descripcion;
	private String nombreCorto;
	private String estatus;
	
	
	public String getGiroID() {
		return giroID;
	}
	public void setGiroID(String giroID) {
		this.giroID = giroID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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