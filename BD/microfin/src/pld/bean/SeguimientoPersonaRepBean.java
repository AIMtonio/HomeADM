package pld.bean;

import general.bean.BaseBean;

public class SeguimientoPersonaRepBean extends BaseBean{
	
	private String fechaInicio;
	private String fechaFin;
	private String fechaSistema;
	private String nombreUsuario;
	private String nombreInstitucion;

	
	/*Datos del reporte*/
	private String folio;
	private String numcliente;
	private String nombreCliente;
	private String fechaDeteccion;
	private String listaDeteccion;
	private String actividadBMX;
	private String permiteOperacion;
	private String comentario;
	
	private String operaciones;
	private String descOperaciones;
	
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getNumcliente() {
		return numcliente;
	}
	public void setNumcliente(String numcliente) {
		this.numcliente = numcliente;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getFechaDeteccion() {
		return fechaDeteccion;
	}
	public void setFechaDeteccion(String fechaDeteccion) {
		this.fechaDeteccion = fechaDeteccion;
	}
	public String getListaDeteccion() {
		return listaDeteccion;
	}
	public void setListaDeteccion(String listaDeteccion) {
		this.listaDeteccion = listaDeteccion;
	}
	public String getActividadBMX() {
		return actividadBMX;
	}
	public void setActividadBMX(String actividadBMX) {
		this.actividadBMX = actividadBMX;
	}
	public String getPermiteOperacion() {
		return permiteOperacion;
	}
	public void setPermiteOperacion(String permiteOperacion) {
		this.permiteOperacion = permiteOperacion;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getOperaciones() {
		return operaciones;
	}
	public void setOperaciones(String operaciones) {
		this.operaciones = operaciones;
	}
	public String getDescOperaciones() {
		return descOperaciones;
	}
	public void setDescOperaciones(String descOperaciones) {
		this.descOperaciones = descOperaciones;
	}
}
