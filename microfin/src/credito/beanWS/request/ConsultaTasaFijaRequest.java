package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaTasaFijaRequest extends BaseBeanWS {
	private String sucursalID;
	private String prodCreID;
	private String numCreditos;
	private String monto;
	private String calificacion;
	
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getProdCreID() {
		return prodCreID;
	}
	public void setProdCreID(String prodCreID) {
		this.prodCreID = prodCreID;
	}
	
	public String getNumCreditos() {
		return numCreditos;
	}
	public void setNumCreditos(String numCreditos) {
		this.numCreditos = numCreditos;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getCalificacion() {
		return calificacion;
	}
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	
}
