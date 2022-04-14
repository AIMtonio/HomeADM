package nomina.bean;

import general.bean.BaseBean;

public class DetalleArchivoInstalBean extends BaseBean{
	private String detalleArchivoID;
	private String folioID;
	private String creditoID;
	private String estatus;
	private String fechaLimiteRecep;
	
	public String getDetalleArchivoID() {
		return detalleArchivoID;
	}
	public void setDetalleArchivoID(String detalleArchivoID) {
		this.detalleArchivoID = detalleArchivoID;
	}
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaLimiteRecep() {
		return fechaLimiteRecep;
	}
	public void setFechaLimiteRecep(String fechaLimiteRecep) {
		this.fechaLimiteRecep = fechaLimiteRecep;
	}
	
}
