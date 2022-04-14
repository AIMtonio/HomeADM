package cuentas.bean;

import general.bean.BaseBean;

public class TiposPlanAhorroBean extends BaseBean{
	
	private String planID;
	private String nombre;
	private String fechaInicio;
	private String fechaVencimiento;
	private String fechaLiberacion;
	private String depositoBase;
	private String maxDep;
	private String serie;
	private String prefijo;
	private String leyendaBloqueo;
	private String leyendaTicket;
	private String tiposCuentas;
	private String diasDesbloqueo;
	
	public String getPlanID() {
		return planID;
	}
	public void setPlanID(String planID) {
		this.planID = planID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getFechaLiberacion() {
		return fechaLiberacion;
	}
	public void setFechaLiberacion(String fechaLiberacion) {
		this.fechaLiberacion = fechaLiberacion;
	}
	public String getDepositoBase() {
		return depositoBase;
	}
	public void setDepositoBase(String depositoBase) {
		this.depositoBase = depositoBase;
	}
	public String getMaxDep() {
		return maxDep;
	}
	public void setMaxDep(String maxDep) {
		this.maxDep = maxDep;
	}
	public String getSerie() {
		return serie;
	}
	public void setSerie(String serie) {
		this.serie = serie;
	}
	public String getPrefijo() {
		return prefijo;
	}
	public void setPrefijo(String prefijo) {
		this.prefijo = prefijo;
	}
	public String getLeyendaBloqueo() {
		return leyendaBloqueo;
	}
	public void setLeyendaBloqueo(String leyendaBloqueo) {
		this.leyendaBloqueo = leyendaBloqueo;
	}
	public String getLeyendaTicket() {
		return leyendaTicket;
	}
	public void setLeyendaTicket(String leyendaTicket) {
		this.leyendaTicket = leyendaTicket;
	}
	public String getTiposCuentas() {
		return tiposCuentas;
	}
	public void setTiposCuentas(String tiposCuentas) {
		this.tiposCuentas = tiposCuentas;
	}
	public String getDiasDesbloqueo() {
		return diasDesbloqueo;
	}
	public void setDiasDesbloqueo(String diasDesbloqueo) {
		this.diasDesbloqueo = diasDesbloqueo;
	}
	
}
