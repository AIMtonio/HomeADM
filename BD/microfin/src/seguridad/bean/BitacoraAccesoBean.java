package seguridad.bean;

import general.bean.BaseBean;

public class BitacoraAccesoBean extends BaseBean{
	private String accesoID;
	private String fecha;
	private String hora;
	private String sucursalID;
	private String usuarioID;
	
	private String perfil;
	private String accesoIP;
	private String recurso;
	private String tipoAcceso;
	
	private String tipoMetodo;
	private String detalleAcceso;
	private String claveUsuario;
	
	public String getAccesoID() {
		return accesoID;
	}
	public void setAccesoID(String accesoID) {
		this.accesoID = accesoID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getPerfil() {
		return perfil;
	}
	public void setPerfil(String perfil) {
		this.perfil = perfil;
	}
	public String getAccesoIP() {
		return accesoIP;
	}
	public void setAccesoIP(String accesoIP) {
		this.accesoIP = accesoIP;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getTipoAcceso() {
		return tipoAcceso;
	}
	public void setTipoAcceso(String tipoAcceso) {
		this.tipoAcceso = tipoAcceso;
	}
	public String getTipoMetodo() {
		return tipoMetodo;
	}
	public void setTipoMetodo(String tipoMetodo) {
		this.tipoMetodo = tipoMetodo;
	}
	public String getDetalleAcceso() {
		return detalleAcceso;
	}
	public void setDetalleAcceso(String detalleAcceso) {
		this.detalleAcceso = detalleAcceso;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
}
