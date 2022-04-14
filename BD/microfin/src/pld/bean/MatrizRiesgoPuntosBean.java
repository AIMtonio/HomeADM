package pld.bean;

import general.bean.BaseBean;

public class MatrizRiesgoPuntosBean extends BaseBean {
	private String matrizCatalogoID;
	private String tipo;
	private String matrizConceptoID;
	private String conceptoDesc;
	private String descripcion;
	private String porcentaje;
	private String orden;
	private String tipoPersona;
	private String mostrarSub;
	private String total;
	
	private String detalles;
	
	public String getMatrizCatalogoID() {
		return matrizCatalogoID;
	}
	public void setMatrizCatalogoID(String matrizCatalogoID) {
		this.matrizCatalogoID = matrizCatalogoID;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getMatrizConceptoID() {
		return matrizConceptoID;
	}
	public void setMatrizConceptoID(String matrizConceptoID) {
		this.matrizConceptoID = matrizConceptoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public String getOrden() {
		return orden;
	}
	public void setOrden(String orden) {
		this.orden = orden;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getMostrarSub() {
		return mostrarSub;
	}
	public void setMostrarSub(String mostrarSub) {
		this.mostrarSub = mostrarSub;
	}
	public String getConceptoDesc() {
		return conceptoDesc;
	}
	public void setConceptoDesc(String conceptoDesc) {
		this.conceptoDesc = conceptoDesc;
	}
	public String getDetalles() {
		return detalles;
	}
	public void setDetalles(String detalles) {
		this.detalles = detalles;
	}
	
}
