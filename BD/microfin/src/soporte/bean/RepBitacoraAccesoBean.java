package soporte.bean;

import general.bean.BaseBean;

public class RepBitacoraAccesoBean extends BaseBean{
	private String fechaInicio;
	private String fechaFin;
	private String usuarioID;
	private String sucursalID;
	private String tipoAcceso;
	
	private String nombreInstitucion;
	private String fechaSistema;
	private String claveUsuario;
	private String nombreUsuario;
	private String nombreSucursal;
	
	public String getFechaInicio() {
		return fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getTipoAcceso() {
		return tipoAcceso;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setTipoAcceso(String tipoAcceso) {
		this.tipoAcceso = tipoAcceso;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	
	

}
