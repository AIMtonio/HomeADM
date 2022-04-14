package soporte.bean;

import general.bean.BaseBean;

public class TarEnvioCorreoParamBean extends BaseBean {
	
	private String remitenteID;
	private String descripcion;
	private String servidorSMTP;
	private String puertoServerSMTP;
	private String tipoSeguridad;
	private String correoSalida;
	private String conAutentificacion;
	private String contrasenia;
	private String estatus;
	private String comentario;
	private String aliasRemitente;
	private String tamanioMax;
	private String tipo;
	
	
	public String getRemitenteID() {
		return remitenteID;
	}
	public void setRemitenteID(String remitenteID) {
		this.remitenteID = remitenteID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getServidorSMTP() {
		return servidorSMTP;
	}
	public void setServidorSMTP(String servidorSMTP) {
		this.servidorSMTP = servidorSMTP;
	}

	public String getTipoSeguridad() {
		return tipoSeguridad;
	}
	public void setTipoSeguridad(String tipoSeguridad) {
		this.tipoSeguridad = tipoSeguridad;
	}
	public String getCorreoSalida() {
		return correoSalida;
	}
	public void setCorreoSalida(String correoSalida) {
		this.correoSalida = correoSalida;
	}
	public String getConAutentificacion() {
		return conAutentificacion;
	}
	public void setConAutentificacion(String conAutentificacion) {
		this.conAutentificacion = conAutentificacion;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getAliasRemitente() {
		return aliasRemitente;
	}
	public void setAliasRemitente(String aliasRemitente) {
		this.aliasRemitente = aliasRemitente;
	}
	public String getPuertoServerSMTP() {
		return puertoServerSMTP;
	}
	public void setPuertoServerSMTP(String puertoServerSMTP) {
		this.puertoServerSMTP = puertoServerSMTP;
	}
	
	public String getTamanioMax() {
		return tamanioMax;
	}
	public void setTamanioMax(String tamanioMax) {
		this.tamanioMax = tamanioMax;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

		
}
