package tesoreria.bean;

public class PresuSucurGridBean {
	String folioID;
	String gridConcepto;
	String gridDescripcion;
	String gridEstatus;	
	String gridMonto;
	String montoDispon;
	String observaciones;
	
	
	
	public String getMontoDispon() {
		return montoDispon;
	}
	public void setMontoDispon(String montoDispon) {
		this.montoDispon = montoDispon;
	}
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getGridEstatus() {
		return gridEstatus;
	}
	public void setGridEstatus(String gridEstatus) {
		this.gridEstatus = gridEstatus;
	}
	public String getGridDescripcion() {
		return gridDescripcion;
	}
	public void setGridDescripcion(String gridDescripcion) {
		this.gridDescripcion = gridDescripcion;
	}
	public String getGridConcepto() {
		return gridConcepto;
	}
	public void setGridConcepto(String gridConcepto) {
		this.gridConcepto = gridConcepto;
	}
	public String getGridMonto() {
		return gridMonto;
	}
	public void setGridMonto(String gridMonto) {
		this.gridMonto = gridMonto;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	
}
