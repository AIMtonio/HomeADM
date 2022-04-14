package cobranza.bean;

import general.bean.BaseBean;

public class GestoresCobranzaBean extends BaseBean{
	private String gestorID;
	private String tipoGestor;
	private String usuarioID;
	private String nombre;
	private String apellidoPaterno;
	
	private String apellidoMaterno;
	private String telefonoParticular;
	private String telefonoCelular;
	private String estadoID;
	private String municipioID;
	
	private String localidadID;
	private String coloniaID;
	private String calle;
	private String numeroCasa;
	private String numInterior;
	
	private String piso;
	private String primeraEntreCalle;
	private String segundaEntreCalle;
	private String CP;
	private String porcentajeComision;
	
	private String tipoAsigCobranzaID;
	private String estatus;
	private String fechaRegistro;
	private String fechaActivacion;
	private String fechaBaja;
	
	private String usuarioRegistroID;
	private String usuarioActivaID;
	private String usuarioBajaID;
	private String nombreCompleto;
	private String descripcion;
	
	private String fechaSis;
	private String usuarioLogeadoID;
	
	public String getGestorID() {
		return gestorID;
	}
	public void setGestorID(String gestorID) {
		this.gestorID = gestorID;
	}
	public String getTipoGestor() {
		return tipoGestor;
	}
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellidoPaterno() {
		return apellidoPaterno;
	}
	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}
	public String getApellidoMaterno() {
		return apellidoMaterno;
	}
	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}
	public String getTelefonoParticular() {
		return telefonoParticular;
	}
	public void setTelefonoParticular(String telefonoParticular) {
		this.telefonoParticular = telefonoParticular;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumeroCasa() {
		return numeroCasa;
	}
	public void setNumeroCasa(String numeroCasa) {
		this.numeroCasa = numeroCasa;
	}
	public String getNumInterior() {
		return numInterior;
	}
	public void setNumInterior(String numInterior) {
		this.numInterior = numInterior;
	}
	public String getPiso() {
		return piso;
	}
	public void setPiso(String piso) {
		this.piso = piso;
	}
	public String getPrimeraEntreCalle() {
		return primeraEntreCalle;
	}
	public void setPrimeraEntreCalle(String primeraEntreCalle) {
		this.primeraEntreCalle = primeraEntreCalle;
	}
	public String getSegundaEntreCalle() {
		return segundaEntreCalle;
	}
	public void setSegundaEntreCalle(String segundaEntreCalle) {
		this.segundaEntreCalle = segundaEntreCalle;
	}
	public String getCP() {
		return CP;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public String getPorcentajeComision() {
		return porcentajeComision;
	}
	public void setPorcentajeComision(String porcentajeComision) {
		this.porcentajeComision = porcentajeComision;
	}
	public String getTipoAsigCobranzaID() {
		return tipoAsigCobranzaID;
	}
	public void setTipoAsigCobranzaID(String tipoAsigCobranzaID) {
		this.tipoAsigCobranzaID = tipoAsigCobranzaID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getFechaActivacion() {
		return fechaActivacion;
	}
	public void setFechaActivacion(String fechaActivacion) {
		this.fechaActivacion = fechaActivacion;
	}
	public String getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public String getUsuarioRegistroID() {
		return usuarioRegistroID;
	}
	public void setUsuarioRegistroID(String usuarioRegistroID) {
		this.usuarioRegistroID = usuarioRegistroID;
	}
	public String getUsuarioActivaID() {
		return usuarioActivaID;
	}
	public void setUsuarioActivaID(String usuarioActivaID) {
		this.usuarioActivaID = usuarioActivaID;
	}
	public String getUsuarioBajaID() {
		return usuarioBajaID;
	}
	public void setUsuarioBajaID(String usuarioBajaID) {
		this.usuarioBajaID = usuarioBajaID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getFechaSis() {
		return fechaSis;
	}
	public void setFechaSis(String fechaSis) {
		this.fechaSis = fechaSis;
	}
	public String getUsuarioLogeadoID() {
		return usuarioLogeadoID;
	}
	public void setUsuarioLogeadoID(String usuarioLogeadoID) {
		this.usuarioLogeadoID = usuarioLogeadoID;
	}
}