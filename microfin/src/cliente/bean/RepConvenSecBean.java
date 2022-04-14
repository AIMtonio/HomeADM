package cliente.bean;

import general.bean.BaseBean;

public class RepConvenSecBean extends BaseBean{
	
	// datos de la pantalla
	private String fechaInicio;
	private String fechaFin;
	private	String tipoRep;
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreUsuario;
	private String horaEmision;
	private String usuario;
	
	
	// datos del reporte
	private String noTarjeta;
	private String noSocio;
	private String nombreCompleto;
	private String fechaAsamblea;
	private String tipoRegistro;
	private String tipoRegistroDes;
	private String sucursalID;
	private String nombreSucurs;
	private String fechaRegistro;

	
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	
	public String getNoTarjeta() {
		return noTarjeta;
	}
	public void setNoTarjeta(String noTarjeta) {
		this.noTarjeta = noTarjeta;
	}
	public String getNoSocio() {
		return noSocio;
	}
	public void setNoSocio(String noSocio) {
		this.noSocio = noSocio;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getFechaAsamblea() {
		return fechaAsamblea;
	}
	public void setFechaAsamblea(String fechaAsamblea) {
		this.fechaAsamblea = fechaAsamblea;
	}
	public String getTipoRegistro() {
		return tipoRegistro;
	}
	public void setTipoRegistro(String tipoRegistro) {
		this.tipoRegistro = tipoRegistro;
	}
	public String getTipoRegistroDes() {
		return tipoRegistroDes;
	}
	public void setTipoRegistroDes(String tipoRegistroDes) {
		this.tipoRegistroDes = tipoRegistroDes;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
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
	
	public String getTipoRep() {
		return tipoRep;
	}
	public void setTipoRep(String tipoRep) {
		this.tipoRep = tipoRep;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}	
	
	

}
