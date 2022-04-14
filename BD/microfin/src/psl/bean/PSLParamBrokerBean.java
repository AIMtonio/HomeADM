package psl.bean;

import general.bean.BaseBean;

public class PSLParamBrokerBean extends BaseBean {
	private String actualizacionDiaria;
	private String horaActualizacion;
	private String usuario;
	private String contrasenia;
	private String urlConexion;
	private String fechaUltimaActualizacion;
	private String actualizandoProductos;
	
	private String llaveParametro;
	private String valorParametro;
	
	
	public String getActualizacionDiaria() {
		return actualizacionDiaria;
	}
	public void setActualizacionDiaria(String actualizacionDiaria) {
		this.actualizacionDiaria = actualizacionDiaria;
	}
	public String getHoraActualizacion() {
		return horaActualizacion;
	}
	public void setHoraActualizacion(String horaActualizacion) {
		this.horaActualizacion = horaActualizacion;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getUrlConexion() {
		return urlConexion;
	}
	public void setUrlConexion(String urlConexion) {
		this.urlConexion = urlConexion;
	}
	public String getLlaveParametro() {
		return llaveParametro;
	}
	public void setLlaveParametro(String llaveParametro) {
		this.llaveParametro = llaveParametro;
	}
	public String getFechaUltimaActualizacion() {
		return fechaUltimaActualizacion;
	}
	public void setFechaUltimaActualizacion(String fechaUltimaActualizacion) {
		this.fechaUltimaActualizacion = fechaUltimaActualizacion;
	}
	public String getActualizandoProductos() {
		return actualizandoProductos;
	}
	public void setActualizandoProductos(String actualizandoProductos) {
		this.actualizandoProductos = actualizandoProductos;
	}
	
	
	public String getValorParametro() {
		return valorParametro;
	}
	public void setValorParametro(String valorParametro) {
		this.valorParametro = valorParametro;
	}
}

