package soporte.bean;

import general.bean.BaseBean;

public class GeneradorXMLEtiquetasBean extends BaseBean{

	private String EtiquetaID;
	private String ReporteID;
	private String Etiqueta;
	private String Descripcion;
	private int Orden;
	private int Tipo;
	private int Nivel;
	
	public String getEtiquetaID() {
		return EtiquetaID;
	}
	public void setEtiquetaID(String etiquetaID) {
		EtiquetaID = etiquetaID;
	}
	public String getReporteID() {
		return ReporteID;
	}
	public void setReporteID(String reporteID) {
		ReporteID = reporteID;
	}
	public String getEtiqueta() {
		return Etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		Etiqueta = etiqueta;
	}
	public String getDescripcion() {
		return Descripcion;
	}
	public void setDescripcion(String descripcion) {
		Descripcion = descripcion;
	}
	public int getOrden() {
		return Orden;
	}
	public void setOrden(int orden) {
		Orden = orden;
	}
	public int getTipo() {
		return Tipo;
	}
	public void setTipo(int tipo) {
		Tipo = tipo;
	}
	public int getNivel() {
		return Nivel;
	}
	public void setNivel(int nivel) {
		Nivel = nivel;
	}
	

	
}
