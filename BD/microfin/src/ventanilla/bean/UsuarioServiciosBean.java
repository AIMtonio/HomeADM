package ventanilla.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class UsuarioServiciosBean extends BaseBean{
	private String usuarioID;
	private String sucursalOrigen;
	private String tipoPersona;
	private String primerNombre;
	private String segundoNombre;
	
	private String tercerNombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String fechaNacimiento;
	private String nacion;
	
	private String paisNacimiento;
	private String estadoNac;
	private String paisResidencia;
	private String sexo;
	private String telefonoCelular;
	
	private String telefonoCasa;
	private String extTelefonoPart;
	private String correo;
	private String CURP;
	private String RFC;
	
	private String FEA;
	private String fechaConstitucion;
	private String ocupacionID;
	private String razonSocial;
	private String tipoSociedadID;
	
	private String RFCpm;
	private String tipoDireccionID;
	private String estadoID;
	private String municipioID;
	private String localidadID;
	
	private String coloniaID;
	private String calle;
	private String numExterior;
	private String numInterior;
	private String piso;
	
	private String CP;
	private String lote;
	private String manzana;
	private String tipoIdentiID;
	private String numIdentific;
	
	private String fecExIden;
	private String fecVenIden;
	
	private String docEstanciaLegal;
	private String docExisLegal;
	private String fechaVenEst;
	private String paisRFC;
	
	private String nombreCompleto;
	private String direccion;
	private String nombreSucursal;
	
	private String usuarioArchivoID;
	private String tipoDocumento;
	private String recurso;
	private String extension;
	private String consecutivo;
	private String observacion;
	private String fechaRegistro;
	
	private String nombreInstitucion;
	private String nombreUsuario;
	private String fechaSistema;
	private String horaEmision;
	private String etiquetaSocio;
	private String desUsuarioID;
	private String descSucursal;
	private String desSexo;
	private String sucursalID;
	private String numCon;
	
	private MultipartFile file;
	
	private String nivelRiesgo;
	private String descripcion;
	private String usuarioUnificadoID;
	private String estatus;
	
	// Atributos Sección Remitentes
	private String remitenteID;
	private String tituloRem;
	private String tipoPersonaRem;
	private String nombreCompletoRem;

	private String fechaNacimientoRem;
	private String paisNacimientoRem;
	private String estadoNacRem;
	private String estadoCivilRem;
	
	private String sexoRem;
	private String CURPRem;
	private String RFCRem;
	private String FEARem;
	private String paisFEARem;
	
	private String ocupacionRem;
	private String puestoRem;
	private String sectorGeneralRem;
	private String actividadBancoMXRem;
	private String actividadINEGIRem;
	
	private String sectorEconomicoRem;
	private String tipoIdentiIDRem;
	private String numIdentificRem;
	private String fecExIdenRem;
	private String fecVenIdenRem;

	private String telefonoCasaRem;
	private String extTelefonoPartRem;
	private String telefonoCelularRem;
	private String correoRem;
	private String domicilioRem;
	
	private String nacionRem;
	private String paisResidenciaRem;
	private String fechaRem;

	private String usuariosID;
	private String coincidencia;

	// Variables para la pantalla de Registro de Huella Funcionalidad 15
	private String personaID;
	private byte[] huellaUno;
	private String dedoHuellaUno;
	private byte[] huellaDos;
	private String dedoHuellaDos;

	private String manoSeleccionada;
	private String dedoSeleccionado;
	private byte[] huella;
	private String origenDatos;
	private byte[] fidImagenHuella;

	public String getUsuarioID() {
		return usuarioID;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public String getPrimerNombre() {
		return primerNombre;
	}
	public String getSegundoNombre() {
		return segundoNombre;
	}
	public String getTercerNombre() {
		return tercerNombre;
	}
	public String getApellidoPaterno() {
		return apellidoPaterno;
	}
	public String getApellidoMaterno() {
		return apellidoMaterno;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public String getNacion() {
		return nacion;
	}
	public String getPaisNacimiento() {
		return paisNacimiento;
	}
	public String getEstadoNac() {
		return estadoNac;
	}
	public String getPaisResidencia() {
		return paisResidencia;
	}
	public String getSexo() {
		return sexo;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public String getTelefonoCasa() {
		return telefonoCasa;
	}
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public String getCorreo() {
		return correo;
	}
	public String getCURP() {
		return CURP;
	}
	public String getRFC() {
		return RFC;
	}
	public String getFEA() {
		return FEA;
	}
	public String getFechaConstitucion() {
		return fechaConstitucion;
	}
	public String getOcupacionID() {
		return ocupacionID;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public String getTipoSociedadID() {
		return tipoSociedadID;
	}
	public String getRFCpm() {
		return RFCpm;
	}
	public String getTipoDireccionID() {
		return tipoDireccionID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public String getCalle() {
		return calle;
	}
	public String getNumExterior() {
		return numExterior;
	}
	public String getNumInterior() {
		return numInterior;
	}
	public String getPiso() {
		return piso;
	}
	public String getCP() {
		return CP;
	}
	public String getLote() {
		return lote;
	}
	public String getManzana() {
		return manzana;
	}
	public String getTipoIdentiID() {
		return tipoIdentiID;
	}
	public String getNumIdentific() {
		return numIdentific;
	}
	public String getFecExIden() {
		return fecExIden;
	}
	public String getFecVenIden() {
		return fecVenIden;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public void setPrimerNombre(String primerNombre) {
		this.primerNombre = primerNombre;
	}
	public void setSegundoNombre(String segundoNombre) {
		this.segundoNombre = segundoNombre;
	}
	public void setTercerNombre(String tercerNombre) {
		this.tercerNombre = tercerNombre;
	}
	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}
	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public void setNacion(String nacion) {
		this.nacion = nacion;
	}
	public void setPaisNacimiento(String paisNacimiento) {
		this.paisNacimiento = paisNacimiento;
	}
	public void setEstadoNac(String estadoNac) {
		this.estadoNac = estadoNac;
	}
	public void setPaisResidencia(String paisResidencia) {
		this.paisResidencia = paisResidencia;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public void setTelefonoCasa(String telefonoCasa) {
		this.telefonoCasa = telefonoCasa;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public void setFEA(String fEA) {
		FEA = fEA;
	}
	public void setFechaConstitucion(String fechaConstitucion) {
		this.fechaConstitucion = fechaConstitucion;
	}
	public void setOcupacionID(String ocupacionID) {
		this.ocupacionID = ocupacionID;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public void setTipoSociedadID(String tipoSociedadID) {
		this.tipoSociedadID = tipoSociedadID;
	}
	public void setRFCpm(String rFCpm) {
		RFCpm = rFCpm;
	}
	public void setTipoDireccionID(String tipoDireccionID) {
		this.tipoDireccionID = tipoDireccionID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public void setNumExterior(String numExterior) {
		this.numExterior = numExterior;
	}
	public void setNumInterior(String numInterior) {
		this.numInterior = numInterior;
	}
	public void setPiso(String piso) {
		this.piso = piso;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	public void setManzana(String manzana) {
		this.manzana = manzana;
	}
	public void setTipoIdentiID(String tipoIdentiID) {
		this.tipoIdentiID = tipoIdentiID;
	}
	public void setNumIdentific(String numIdentific) {
		this.numIdentific = numIdentific;
	}
	public void setFecExIden(String fecExIden) {
		this.fecExIden = fecExIden;
	}
	public void setFecVenIden(String fecVenIden) {
		this.fecVenIden = fecVenIden;
	}
	public String getDocEstanciaLegal() {
		return docEstanciaLegal;
	}
	public String getDocExisLegal() {
		return docExisLegal;
	}
	public String getFechaVenEst() {
		return fechaVenEst;
	}
	public String getPaisRFC() {
		return paisRFC;
	}
	public void setDocEstanciaLegal(String docEstanciaLegal) {
		this.docEstanciaLegal = docEstanciaLegal;
	}
	public void setDocExisLegal(String docExisLegal) {
		this.docExisLegal = docExisLegal;
	}
	public void setFechaVenEst(String fechaVenEst) {
		this.fechaVenEst = fechaVenEst;
	}
	public void setPaisRFC(String paisRFC) {
		this.paisRFC = paisRFC;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getDireccion() {
		return direccion;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getUsuarioArchivoID() {
		return usuarioArchivoID;
	}
	public void setUsuarioArchivoID(String usuarioArchivoID) {
		this.usuarioArchivoID = usuarioArchivoID;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getExtension() {
		return extension;
	}
	public void setExtension(String extension) {
		this.extension = extension;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
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
	public String getEtiquetaSocio() {
		return etiquetaSocio;
	}
	public void setEtiquetaSocio(String etiquetaSocio) {
		this.etiquetaSocio = etiquetaSocio;
	}
	public String getDesUsuarioID() {
		return desUsuarioID;
	}
	public void setDesUsuarioID(String desUsuarioID) {
		this.desUsuarioID = desUsuarioID;
	}
	public String getDescSucursal() {
		return descSucursal;
	}
	public void setDescSucursal(String descSucursal) {
		this.descSucursal = descSucursal;
	}
	public String getDesSexo() {
		return desSexo;
	}
	public void setDesSexo(String desSexo) {
		this.desSexo = desSexo;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNumCon() {
		return numCon;
	}
	public void setNumCon(String numCon) {
		this.numCon = numCon;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getUsuarioUnificadoID() {
		return usuarioUnificadoID;
	}
	public void setUsuarioUnificadoID(String usuarioUnificadoID) {
		this.usuarioUnificadoID = usuarioUnificadoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getRemitenteID() {
		return remitenteID;
	}
	public void setRemitenteID(String remitenteID) {
		this.remitenteID = remitenteID;
	}
	public String getTituloRem() {
		return tituloRem;
	}
	public void setTituloRem(String tituloRem) {
		this.tituloRem = tituloRem;
	}
	public String getTipoPersonaRem() {
		return tipoPersonaRem;
	}
	public void setTipoPersonaRem(String tipoPersonaRem) {
		this.tipoPersonaRem = tipoPersonaRem;
	}
	public String getNombreCompletoRem() {
		return nombreCompletoRem;
	}
	public void setNombreCompletoRem(String nombreCompletoRem) {
		this.nombreCompletoRem = nombreCompletoRem;
	}
	public String getFechaNacimientoRem() {
		return fechaNacimientoRem;
	}
	public void setFechaNacimientoRem(String fechaNacimientoRem) {
		this.fechaNacimientoRem = fechaNacimientoRem;
	}
	public String getPaisNacimientoRem() {
		return paisNacimientoRem;
	}
	public void setPaisNacimientoRem(String paisNacimientoRem) {
		this.paisNacimientoRem = paisNacimientoRem;
	}
	public String getEstadoNacRem() {
		return estadoNacRem;
	}
	public void setEstadoNacRem(String estadoNacRem) {
		this.estadoNacRem = estadoNacRem;
	}
	public String getEstadoCivilRem() {
		return estadoCivilRem;
	}
	public void setEstadoCivilRem(String estadoCivilRem) {
		this.estadoCivilRem = estadoCivilRem;
	}
	public String getSexoRem() {
		return sexoRem;
	}
	public void setSexoRem(String sexoRem) {
		this.sexoRem = sexoRem;
	}
	public String getCURPRem() {
		return CURPRem;
	}
	public void setCURPRem(String cURPRem) {
		CURPRem = cURPRem;
	}
	public String getRFCRem() {
		return RFCRem;
	}
	public void setRFCRem(String rFCRem) {
		RFCRem = rFCRem;
	}
	public String getFEARem() {
		return FEARem;
	}
	public void setFEARem(String fEARem) {
		FEARem = fEARem;
	}
	public String getPaisFEARem() {
		return paisFEARem;
	}
	public void setPaisFEARem(String paisFEARem) {
		this.paisFEARem = paisFEARem;
	}
	public String getOcupacionRem() {
		return ocupacionRem;
	}
	public void setOcupacionRem(String ocupacionRem) {
		this.ocupacionRem = ocupacionRem;
	}
	public String getPuestoRem() {
		return puestoRem;
	}
	public void setPuestoRem(String puestoRem) {
		this.puestoRem = puestoRem;
	}
	public String getSectorGeneralRem() {
		return sectorGeneralRem;
	}
	public void setSectorGeneralRem(String sectorGeneralRem) {
		this.sectorGeneralRem = sectorGeneralRem;
	}
	public String getActividadBancoMXRem() {
		return actividadBancoMXRem;
	}
	public void setActividadBancoMXRem(String actividadBancoMXRem) {
		this.actividadBancoMXRem = actividadBancoMXRem;
	}
	public String getActividadINEGIRem() {
		return actividadINEGIRem;
	}
	public void setActividadINEGIRem(String actividadINEGIRem) {
		this.actividadINEGIRem = actividadINEGIRem;
	}
	public String getSectorEconomicoRem() {
		return sectorEconomicoRem;
	}
	public void setSectorEconomicoRem(String sectorEconomicoRem) {
		this.sectorEconomicoRem = sectorEconomicoRem;
	}
	public String getTipoIdentiIDRem() {
		return tipoIdentiIDRem;
	}
	public void setTipoIdentiIDRem(String tipoIdentiIDRem) {
		this.tipoIdentiIDRem = tipoIdentiIDRem;
	}
	public String getNumIdentificRem() {
		return numIdentificRem;
	}
	public void setNumIdentificRem(String numIdentificRem) {
		this.numIdentificRem = numIdentificRem;
	}
	public String getFecExIdenRem() {
		return fecExIdenRem;
	}
	public void setFecExIdenRem(String fecExIdenRem) {
		this.fecExIdenRem = fecExIdenRem;
	}
	public String getFecVenIdenRem() {
		return fecVenIdenRem;
	}
	public void setFecVenIdenRem(String fecVenIdenRem) {
		this.fecVenIdenRem = fecVenIdenRem;
	}
	public String getTelefonoCasaRem() {
		return telefonoCasaRem;
	}
	public void setTelefonoCasaRem(String telefonoCasaRem) {
		this.telefonoCasaRem = telefonoCasaRem;
	}
	public String getExtTelefonoPartRem() {
		return extTelefonoPartRem;
	}
	public void setExtTelefonoPartRem(String extTelefonoPartRem) {
		this.extTelefonoPartRem = extTelefonoPartRem;
	}
	public String getTelefonoCelularRem() {
		return telefonoCelularRem;
	}
	public void setTelefonoCelularRem(String telefonoCelularRem) {
		this.telefonoCelularRem = telefonoCelularRem;
	}
	public String getCorreoRem() {
		return correoRem;
	}
	public void setCorreoRem(String correoRem) {
		this.correoRem = correoRem;
	}
	public String getDomicilioRem() {
		return domicilioRem;
	}
	public void setDomicilioRem(String domicilioRem) {
		this.domicilioRem = domicilioRem;
	}
	public String getNacionRem() {
		return nacionRem;
	}
	public void setNacionRem(String nacionRem) {
		this.nacionRem = nacionRem;
	}
	public String getPaisResidenciaRem() {
		return paisResidenciaRem;
	}
	public void setPaisResidenciaRem(String paisResidenciaRem) {
		this.paisResidenciaRem = paisResidenciaRem;
	}
	public String getFechaRem() {
		return fechaRem;
	}
	public void setFechaRem(String fechaRem) {
		this.fechaRem = fechaRem;
	}
	public String getUsuariosID() {
		return usuariosID;
	}
	public void setUsuariosID(String usuariosID) {
		this.usuariosID = usuariosID;
	}
	public String getCoincidencia() {
		return coincidencia;
	}
	public void setCoincidencia(String coincidencia) {
		this.coincidencia = coincidencia;
	}
	public String getPersonaID() {
		return personaID;
	}
	public void setPersonaID(String personaID) {
		this.personaID = personaID;
	}
	public byte[] getHuellaUno() {
		return huellaUno;
	}
	public void setHuellaUno(byte[] huellaUno) {
		this.huellaUno = huellaUno;
	}
	public String getDedoHuellaUno() {
		return dedoHuellaUno;
	}
	public void setDedoHuellaUno(String dedoHuellaUno) {
		this.dedoHuellaUno = dedoHuellaUno;
	}
	public byte[] getHuellaDos() {
		return huellaDos;
	}
	public void setHuellaDos(byte[] huellaDos) {
		this.huellaDos = huellaDos;
	}
	public String getDedoHuellaDos() {
		return dedoHuellaDos;
	}
	public void setDedoHuellaDos(String dedoHuellaDos) {
		this.dedoHuellaDos = dedoHuellaDos;
	}
	public String getManoSeleccionada() {
		return manoSeleccionada;
	}
	public void setManoSeleccionada(String manoSeleccionada) {
		this.manoSeleccionada = manoSeleccionada;
	}
	public String getDedoSeleccionado() {
		return dedoSeleccionado;
	}
	public void setDedoSeleccionado(String dedoSeleccionado) {
		this.dedoSeleccionado = dedoSeleccionado;
	}
	public byte[] getHuella() {
		return huella;
	}
	public void setHuella(byte[] huella) {
		this.huella = huella;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	public byte[] getFidImagenHuella() {
		return fidImagenHuella;
	}
	public void setFidImagenHuella(byte[] fidImagenHuella) {
		this.fidImagenHuella = fidImagenHuella;
	}
	
}

