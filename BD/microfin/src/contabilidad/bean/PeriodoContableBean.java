package contabilidad.bean;

import general.bean.BaseBean;

public class PeriodoContableBean extends BaseBean {

	//Declaracion de Constantes
	public static String STATUS_PERIODO_CERRADO = "C"; 
	public static String STATUS_PERIODO_VIGENTE = "N";
	
	//Declaracion de Variables
	private String numeroEjercicio;
	private String numeroPeriodo;
	private String inicioPeriodo;
	private String finPeriodo;
	private String fechaCierre;
	private String usuarioCierre;
	private String tipoPeriodo;
	private String status;
	private String empresa;
	private String fecha;
	
	
	public String getNumeroEjercicio() {
		return numeroEjercicio;
	}
	public void setNumeroEjercicio(String numeroEjercicio) {
		this.numeroEjercicio = numeroEjercicio;
	}
	public String getNumeroPeriodo() {
		return numeroPeriodo;
	}
	public void setNumeroPeriodo(String numeroPeriodo) {
		this.numeroPeriodo = numeroPeriodo;
	}
	public String getInicioPeriodo() {
		return inicioPeriodo;
	}
	public void setInicioPeriodo(String inicioPeriodo) {
		this.inicioPeriodo = inicioPeriodo;
	}
	public String getFinPeriodo() {
		return finPeriodo;
	}
	public void setFinPeriodo(String finPeriodo) {
		this.finPeriodo = finPeriodo;
	}
	public String getFechaCierre() {
		return fechaCierre;
	}
	public void setFechaCierre(String fechaCierre) {
		this.fechaCierre = fechaCierre;
	}
	public String getUsuarioCierre() {
		return usuarioCierre;
	}
	public void setUsuarioCierre(String usuarioCierre) {
		this.usuarioCierre = usuarioCierre;
	}
	public String getTipoPeriodo() {
		return tipoPeriodo;
	}
	public void setTipoPeriodo(String tipoPeriodo) {
		this.tipoPeriodo = tipoPeriodo;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getEmpresa() {
		return empresa;
	}
	public void setEmpresa(String empresa) {
		this.empresa = empresa;
	}
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
}
