package cliente.bean;

import java.util.List;

import general.bean.BaseBean;

public class GruposNosolidariosBean extends BaseBean{
	private String grupoID;
	private String nombreGrupo;
	private String fechaRegistro;
	private String sucursalID;
	private String numIntegrantes;
	private String promotorID;
	private String lugarReunion;
	private String diaReunion;
	private String horaReunion;
	private String ahoObligatorio;
	private String plazoCredito;
	private String costoAusencia;
	private String ahorroCompro;
	private String moraCredito;
	private String estadoID;
	private String municipioID;
	private String ubicacion;
	private String estatus;
	
	//auxiliares para el grid de Integrantes
	private List	lclientes;
	private List	ltipoIntegrante;
	
	//auxiliares para el Reporte
	private String grupoIni;
	private String grupoIniDes;
	private String grupoFin;
	private String grupoFinDes;
	private String promotorIni;
	private String promotorIniDes;
	private String promotorFin;
	private String promotorFinDes;
	private String sucursal;
	private String sucursalDes;
	private String clienteID;
	private String nombreCompleto;
	private String nombrePromotor;
	private String nombreSucursal;
	private String ahorro;
	private String exigibleDia;
	private String totalDia;
	private String tipoIntegrante;
	private String esMenorEdad;

	private String nombreInstitucion;
	private String nombreUsuario;
	private String fechaEmision;
	private String horaEmision;
	
	/* para WS */
	private String NumSocio;
	private String Nombre;
	private String ApPaterno;
	private String ApMaterno;
	private String FecNacimiento;
	private String Rfc;
	
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNumIntegrantes() {
		return numIntegrantes;
	}
	public void setNumIntegrantes(String numIntegrantes) {
		this.numIntegrantes = numIntegrantes;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getLugarReunion() {
		return lugarReunion;
	}
	public void setLugarReunion(String lugarReunion) {
		this.lugarReunion = lugarReunion;
	}
	public String getDiaReunion() {
		return diaReunion;
	}
	public void setDiaReunion(String diaReunion) {
		this.diaReunion = diaReunion;
	}
	public String getHoraReunion() {
		return horaReunion;
	}
	public void setHoraReunion(String horaReunion) {
		this.horaReunion = horaReunion;
	}
	public String getAhoObligatorio() {
		return ahoObligatorio;
	}
	public void setAhoObligatorio(String ahoObligatorio) {
		this.ahoObligatorio = ahoObligatorio;
	}
	public String getPlazoCredito() {
		return plazoCredito;
	}
	public void setPlazoCredito(String plazoCredito) {
		this.plazoCredito = plazoCredito;
	}
	public String getCostoAusencia() {
		return costoAusencia;
	}
	public void setCostoAusencia(String costoAusencia) {
		this.costoAusencia = costoAusencia;
	}
	public String getAhorroCompro() {
		return ahorroCompro;
	}
	public void setAhorroCompro(String ahorroCompro) {
		this.ahorroCompro = ahorroCompro;
	}
	public String getMoraCredito() {
		return moraCredito;
	}
	public void setMoraCredito(String moraCredito) {
		this.moraCredito = moraCredito;
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
	public String getUbicacion() {
		return ubicacion;
	}
	public void setUbicacion(String ubicacion) {
		this.ubicacion = ubicacion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public List getLclientes() {
		return lclientes;
	}
	public void setLclientes(List lclientes) {
		this.lclientes = lclientes;
	}
	public List getLtipoIntegrante() {
		return ltipoIntegrante;
	}
	public void setLtipoIntegrante(List ltipoIntegrante) {
		this.ltipoIntegrante = ltipoIntegrante;
	}

	public String getNumSocio() {
		return NumSocio;
	}
	public String getNombre() {
		return Nombre;
	}
	public String getApPaterno() {
		return ApPaterno;
	}
	public String getApMaterno() {
		return ApMaterno;
	}
	public String getFecNacimiento() {
		return FecNacimiento;
	}
	public String getRfc() {
		return Rfc;
	}
	public void setNumSocio(String numSocio) {
		NumSocio = numSocio;
	}
	public void setNombre(String nombre) {
		Nombre = nombre;
	}
	public void setApPaterno(String apPaterno) {
		ApPaterno = apPaterno;
	}
	public void setApMaterno(String apMaterno) {
		ApMaterno = apMaterno;
	}
	public void setFecNacimiento(String fecNacimiento) {
		FecNacimiento = fecNacimiento;
	}
	public void setRfc(String rfc) {
		Rfc = rfc;
	}
	public String getGrupoIni() {
		return grupoIni;
	}
	public void setGrupoIni(String grupoIni) {
		this.grupoIni = grupoIni;
	}
	public String getGrupoIniDes() {
		return grupoIniDes;
	}
	public void setGrupoIniDes(String grupoIniDes) {
		this.grupoIniDes = grupoIniDes;
	}
	public String getGrupoFin() {
		return grupoFin;
	}
	public void setGrupoFin(String grupoFin) {
		this.grupoFin = grupoFin;
	}
	public String getGrupoFinDes() {
		return grupoFinDes;
	}
	public void setGrupoFinDes(String grupoFinDes) {
		this.grupoFinDes = grupoFinDes;
	}
	public String getPromotorIni() {
		return promotorIni;
	}
	public void setPromotorIni(String promotorIni) {
		this.promotorIni = promotorIni;
	}
	public String getPromotorIniDes() {
		return promotorIniDes;
	}
	public void setPromotorIniDes(String promotorIniDes) {
		this.promotorIniDes = promotorIniDes;
	}
	public String getPromotorFin() {
		return promotorFin;
	}
	public void setPromotorFin(String promotorFin) {
		this.promotorFin = promotorFin;
	}
	public String getPromotorFinDes() {
		return promotorFinDes;
	}
	public void setPromotorFinDes(String promotorFinDes) {
		this.promotorFinDes = promotorFinDes;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getSucursalDes() {
		return sucursalDes;
	}
	public void setSucursalDes(String sucursalDes) {
		this.sucursalDes = sucursalDes;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getAhorro() {
		return ahorro;
	}
	public void setAhorro(String ahorro) {
		this.ahorro = ahorro;
	}
	public String getExigibleDia() {
		return exigibleDia;
	}
	public void setExigibleDia(String exigibleDia) {
		this.exigibleDia = exigibleDia;
	}
	public String getTotalDia() {
		return totalDia;
	}
	public void setTotalDia(String totalDia) {
		this.totalDia = totalDia;
	}
	public String getTipoIntegrante() {
		return tipoIntegrante;
	}
	public void setTipoIntegrante(String tipoIntegrante) {
		this.tipoIntegrante = tipoIntegrante;
	}
	public String getEsMenorEdad() {
		return esMenorEdad;
	}
	public void setEsMenorEdad(String esMenorEdad) {
		this.esMenorEdad = esMenorEdad;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}

	
}
