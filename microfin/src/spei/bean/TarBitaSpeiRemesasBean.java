package spei.bean;

import general.bean.BaseBean;

public class TarBitaSpeiRemesasBean extends BaseBean {

	private String speiRemID;	
	private String claveRastreo;
	private String metodo;
	private String estatus;
	private String pIDTarea;
	private String observacion;
	private String fechaHoraAlta;

	public String getSpeiRemID() {
		return speiRemID;
	}
	public void setSpeiRemID(String speiRemID) {
		this.speiRemID = speiRemID;
	}
	public String getClaveRastreo() {
		return claveRastreo;
	}
	public void setClaveRastreo(String claveRastreo) {
		this.claveRastreo = claveRastreo;
	}
	public String getMetodo() {
		return metodo;
	}
	public void setMetodo(String metodo) {
		this.metodo = metodo;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getpIDTarea() {
		return pIDTarea;
	}
	public void setpIDTarea(String pIDTarea) {
		this.pIDTarea = pIDTarea;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public String getFechaHoraAlta() {
		return fechaHoraAlta;
	}
	public void setFechaHoraAlta(String fechaHoraAlta) {
		this.fechaHoraAlta = fechaHoraAlta;
	}
}
