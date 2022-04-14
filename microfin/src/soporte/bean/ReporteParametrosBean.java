package soporte.bean;

import general.bean.BaseBean;

public class ReporteParametrosBean extends BaseBean{

	String reporteID;
	String nombreParametro;
	int orden;
	int tipo;/*1:Entero 2:Varchar 3:Decmal 4:Date*/
	public String getReporteID() {
		return reporteID;
	}
	public void setReporteID(String reporteID) {
		this.reporteID = reporteID;
	}
	public String getNombreParametro() {
		return nombreParametro;
	}
	public void setNombreParametro(String nombreParametro) {
		this.nombreParametro = nombreParametro;
	}
	public int getOrden() {
		return orden;
	}
	public void setOrden(int orden) {
		this.orden = orden;
	}
	public int getTipo() {
		return tipo;
	}
	public void setTipo(int tipo) {
		this.tipo = tipo;
	}
}
