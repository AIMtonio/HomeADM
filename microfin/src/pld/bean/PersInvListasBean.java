package pld.bean;

import general.bean.BaseBean;

public class PersInvListasBean extends BaseBean {
	
	private String clavePersonaInv;
	private String nombreCompleto;
	private String fechaAlta;
	private String fechaIniTran;
	private String numeroOficio;
	private String sucursal;
	private String nombreInstitucion;
	private String tipoLista;
	private String usuario;
	private String fechaSistema;
	private String horaEmision;
	private String sucursalDes;
	private String origenDeteccion;

	public String getClavePersonaInv() {
		return clavePersonaInv;
	}

	public void setClavePersonaInv(String clavePersonaInv) {
		this.clavePersonaInv = clavePersonaInv;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getFechaIniTran() {
		return fechaIniTran;
	}

	public void setFechaIniTran(String fechaIniTran) {
		this.fechaIniTran = fechaIniTran;
	}

	public String getNumeroOficio() {
		return numeroOficio;
	}

	public void setNumeroOficio(String numeroOficio) {
		this.numeroOficio = numeroOficio;
	}

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getTipoLista() {
		return tipoLista;
	}

	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public String getHoraEmision() {
		return horaEmision;
	}

	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}

	public String getSucursalDes() {
		return sucursalDes;
	}

	public void setSucursalDes(String sucursalDes) {
		this.sucursalDes = sucursalDes;
	}

	public String getOrigenDeteccion() {
		return origenDeteccion;
	}

	public void setOrigenDeteccion(String origenDeteccion) {
		this.origenDeteccion = origenDeteccion;
	}

}