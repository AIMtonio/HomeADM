package contabilidad.bean;

import general.bean.BaseBean;

public class EjercicioContableBean extends BaseBean{
	
	//Declaracion de Constantes
	public static String STATUS_EJERCICIO_CERRADO = "C"; 
	public static String STATUS_EJERCICIO_VIGENTE = "N";
	
	//Declaracion de Variables
	private String numeroEjercicio;
	private String tipoEjercicio;
	private String inicioEjercicio;
	private String finEjercicio;
	private String fechaCierre;
	private String usuarioCierre;
	private String status;
	private String empresa;
	private String tipoPeriodo;
	
	public String getNumeroEjercicio() {
		return numeroEjercicio;
	}
	public void setNumeroEjercicio(String numeroEjercicio) {
		this.numeroEjercicio = numeroEjercicio;
	}
	public String getInicioEjercicio() {
		return inicioEjercicio;
	}
	public void setInicioEjercicio(String inicioEjercicio) {
		this.inicioEjercicio = inicioEjercicio;
	}
	public String getFinEjercicio() {
		return finEjercicio;
	}
	public void setFinEjercicio(String finEjercicio) {
		this.finEjercicio = finEjercicio;
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
	public String getTipoEjercicio() {
		return tipoEjercicio;
	}
	public void setTipoEjercicio(String tipoEjercicio) {
		this.tipoEjercicio = tipoEjercicio;
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
	
	
	
}
