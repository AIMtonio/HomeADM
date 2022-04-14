package ventanilla.bean;

import general.bean.BaseBean;

public class ReporteCoincidenciasRemesasBean extends BaseBean{
	
	private String fechaInicial;
	private String fechaFinal;
	private String tipoCoincidencia;
	
	private String usuarioBuscado;
	private String rFCBuscado;
	private String cURPBuscado;
	private String nombreBuscado;
	private String usuarioCoincidencia;
	private String rFCCoincidencia;
	private String cURPCoincidencia;
	private String nombreCoincidencia;
	private String porcentajeCoincidencia;
	
	
	public String getFechaInicial() {
		return fechaInicial;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getTipoCoincidencia() {
		return tipoCoincidencia;
	}
	public void setTipoCoincidencia(String tipoCoincidencia) {
		this.tipoCoincidencia = tipoCoincidencia;
	}
	public String getUsuarioBuscado() {
		return usuarioBuscado;
	}
	public void setUsuarioBuscado(String usuarioBuscado) {
		this.usuarioBuscado = usuarioBuscado;
	}
	public String getrFCBuscado() {
		return rFCBuscado;
	}
	public void setrFCBuscado(String rFCBuscado) {
		this.rFCBuscado = rFCBuscado;
	}
	public String getcURPBuscado() {
		return cURPBuscado;
	}
	public void setcURPBuscado(String cURPBuscado) {
		this.cURPBuscado = cURPBuscado;
	}
	public String getNombreBuscado() {
		return nombreBuscado;
	}
	public void setNombreBuscado(String nombreBuscado) {
		this.nombreBuscado = nombreBuscado;
	}
	public String getUsuarioCoincidencia() {
		return usuarioCoincidencia;
	}
	public void setUsuarioCoincidencia(String usuarioCoincidencia) {
		this.usuarioCoincidencia = usuarioCoincidencia;
	}
	public String getrFCCoincidencia() {
		return rFCCoincidencia;
	}
	public void setrFCCoincidencia(String rFCCoincidencia) {
		this.rFCCoincidencia = rFCCoincidencia;
	}
	public String getcURPCoincidencia() {
		return cURPCoincidencia;
	}
	public void setcURPCoincidencia(String cURPCoincidencia) {
		this.cURPCoincidencia = cURPCoincidencia;
	}
	public String getNombreCoincidencia() {
		return nombreCoincidencia;
	}
	public void setNombreCoincidencia(String nombreCoincidencia) {
		this.nombreCoincidencia = nombreCoincidencia;
	}
	public String getPorcentajeCoincidencia() {
		return porcentajeCoincidencia;
	}
	public void setPorcentajeCoincidencia(String porcentajeCoincidencia) {
		this.porcentajeCoincidencia = porcentajeCoincidencia;
	}
	
	
}
