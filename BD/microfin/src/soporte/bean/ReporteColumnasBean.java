package soporte.bean;

import general.bean.BaseBean;

public class ReporteColumnasBean extends BaseBean{

	String reporteID;
	String nombreColumna;
	int orden;
	int tipo;/*1:Entero 2:Varchar 3:Decmal 4:Date*/
	
	public String getReporteID() {
		return reporteID;
	}
	public void setReporteID(String reporteID) {
		this.reporteID = reporteID;
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
	public String getNombreColumna() {
		return nombreColumna;
	}
	public void setNombreColumna(String nombreColumna) {
		this.nombreColumna = nombreColumna;
	}
	
}
